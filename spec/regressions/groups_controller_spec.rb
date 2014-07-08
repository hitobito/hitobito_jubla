# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'
describe GroupsController, type: :controller  do
  include CrudControllerTestHelper
  render_views

  let(:asterix)  { groups(:asterix) }
  let(:flock) { groups(:bern) }
  let(:agency) { groups(:be_agency) }
  let(:region) { groups(:city) }
  let(:state) { groups(:be) }


  let(:leader) { Fabricate(Group::Flock::Leader.name.to_sym, group: flock).person }
  let(:agent) { Fabricate(Group::StateAgency::Leader.name.to_sym, group: groups(:be_agency)).person }
  let(:bulei) { Fabricate(Group::FederalBoard::Member.name.to_sym, group: groups(:federal_board)).person }

  let(:dom) { Capybara::Node::Simple.new(response.body) }

  let(:default_attrs) { { name: 'dummy' } }

  describe_action :get, :show, id: true do
    before { sign_in(bulei) }

    context :json, perform_request: false do
      it 'contains all jubla flock attrs' do
        flock.update_attributes(founding_year: 1950, bank_account: '123-456')
        get :show, id: flock.id, format: :json
        json = JSON.parse(response.body)
        group = json['groups'].first
        group['founding_year'].should eq(1950)
        group['bank_account'].should eq('123-456')
        group.should have_key('unsexed')
      end

      it 'contains all jubla state attrs' do
        get :show, id: state.id, format: :json
        json = JSON.parse(response.body)
        group = json['groups'].first
        group.should have_key('bank_account')
        group.should_not have_key('parish')
        group.should_not have_key('unsexed')
      end
    end
  end

  describe_action :get, :edit, id: true do
    expected = [
      [:leader, :flock, false],
      [:agent, :flock, true],
      [:agent, :region, true],
      [:agent, :state, false]
    ]

    expected.each do |user, group, super_attr_present|
      context "#{user} on #{group}" do
        before { sign_in(send(user)) }
        it " #{super_attr_present ? "can" : "cannot"} see superior_attributes" do
          get :edit, id: send(group).id
          matcher_for(super_attr_present) =~ /Jubla Versicherung/
        end
      end

    end

    def matcher_for(super_attr_present)
      super_attr_present ? :should : :should_not
    end
  end

  describe_action :get, :new do
    expected = [
      [:leader, :asterix, true],
      [:agent, :flock, true],
      [:agent, :region, true],
    ]
    expected.each do |user, group, can_render_form|
      context "#{user} new #{group}"  do
        before { sign_in(send(user)) }

        it 'can render form' do
          get :new, group: { type: send(group).type, parent_id: send(group).parent.id }
          dom.should have_selector('form[action="/groups"]')
        end
      end
    end

    expected = [
      [:leader, :flock, false],
      [:agent, :state, false]
    ]
    expected.each do |user, group, can_render_form|
      context "#{user} new #{group}"  do
        before { sign_in(send(user)) }

        it 'cannot render form' do
          expect do
            get :new, group: { type: send(group).type, parent_id: send(group).parent.id }
          end.to raise_error(CanCan::AccessDenied)
        end
      end
    end
  end

  describe_action :put, :update, id: true do
    expected = [
      [:leader, :flock, true],
      [:leader, :flock, false, { jubla_insurance: '1' }],
      [:agent, :flock, true, { jubla_insurance: '1' }],
      [:agent, :region, true, { jubla_insurance: '1' }],
      [:agent, :state, true],
      [:agent, :state, false, { jubla_insurance: '1' }],
      [:bulei, :state, true, { jubla_insurance: '1' }],
    ]

    expected.each do |user, group, super_attr_update, extra_attrs = {} |
      context "#{user} on #{group}" do
        before { sign_in(send(user)) }
        it "#{super_attr_update ? "can" : "cannot"} update with #{extra_attrs}" do
          attrs = default_attrs.merge(extra_attrs)
          put :update, id: send(group).id, group: attrs
          if super_attr_update
            assigns(:group).name.should eq 'dummy'
            assigns(:group).jubla_insurance.should be_true if extra_attrs.present?
          else
            assigns(:group).jubla_insurance.should be_false if extra_attrs.present?
          end
        end
      end
    end
  end


  describe_action :post, :create do
    expected = [
      [:leader, :asterix, true],
      [:leader, :asterix, false, { jubla_insurance: '1' }],
      [:leader, :flock, false],
      [:agent, :flock, true],
      [:agent, :region, true],
      [:agent, :state, false]
    ]

    expected.each do |user, group, can_create_group, extra_attrs = {}|
      context "#{user} on #{group}"  do
        before { sign_in(send(user)) }

        it "#{can_create_group ? "can" : "cannot"} create group" do
          attrs = default_attrs.merge(type: send(group).type, parent_id: send(group).parent.id)
          attrs = attrs.merge(extra_attrs)
          if can_create_group
            expect { post :create, group: attrs }.to change(Group, :count).by(change_count(group))
            should redirect_to group_path(assigns(:group))
          else
            if extra_attrs.empty?
              expect do
                expect { post :create, group: attrs }.to raise_error(CanCan::AccessDenied)
              end.not_to change(Group, :count)
            else
              post :create, group: attrs
              assigns(:group).jubla_insurance.should be_false
            end
          end
        end
      end
    end

    def change_count(group)
      (send(group).class.default_children.size + 1)
    end
  end


  describe_action :delete, :destroy do
    [[:leader, :asterix, true],
     [:agent, :asterix, true],
    ].each do |user, group, can_destroy_group|
      context "#{user} destroy #{group}"  do
        before { sign_in(send(user)) }

        it 'can destroy group' do
          expect { delete :destroy, id: send(group).id }.to change { Group.without_deleted.count }.by(-1)
        end
      end
    end

    [[:agent, :flock, false],
     [:agent, :region, false],
    ].each do |user, group, can_destroy_group|
      context "#{user} destroy #{group}"  do
        before { sign_in(send(user)) }

        it 'cannot destroy group with children' do
          expect { delete :destroy, id: send(group).id }.not_to change { Group.without_deleted.count }
        end
      end
    end

    [[:leader, :flock, false],
     [:agent, :state, false]
    ].each do |user, group, can_destroy_group|
      context "#{user} destroy #{group}"  do
        before { sign_in(send(user)) }

        it 'is not allowed to destroy group' do
          expect { delete :destroy, id: send(group).id }.to raise_error(CanCan::AccessDenied)
        end
      end
    end
  end

  context 'agent' do
    before { sign_in(agent) }

    it 'can destroy flock without subgroups' do
      flock.children.destroy_all
      expect { delete :destroy, id: flock.id }.to change { Group.without_deleted.count }.by(-1)
    end
  end

  context 'flock leader' do
    before { sign_in(leader) }

    it 'cannot destroy flock without subgroups' do
      flock.children.destroy_all
      expect do
         expect { delete :destroy, id: flock.id }.to raise_error(CanCan::AccessDenied)
      end.not_to change { Group.count }
    end
  end
end
