# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Event::CampsController do

  before { sign_in(user) }

  let(:user) { people(:top_leader) }
  subject { assigns(:camps).values.flatten }

  describe 'GET all_camps' do
    let!(:current) do
      Fabricate(:camp, dates: [Fabricate(:event_date, start_at: 15.days.ago, finish_at: 10.days.ago),
                               Fabricate(:event_date, start_at: 5.days.ago, finish_at: 5.days.from_now)])
    end

    let!(:upcoming_in_range) do
      Fabricate(:camp, dates: [Fabricate(:event_date, start_at: 10.days.from_now, finish_at: nil),
                               Fabricate(:event_date, start_at: 12.days.from_now, finish_at: nil)])
    end

    let!(:upcoming_outside_range) do
      Fabricate(:camp, dates: [Fabricate(:event_date, start_at: 50.days.from_now, finish_at: 55.days.from_now)])
    end

    let!(:past) do
      Fabricate(:camp, dates: [Fabricate(:event_date, start_at: 5.days.ago, finish_at: nil)])
    end

    [[Group::Federation::ItSupport, :ch], [Group::FederalBoard::Member, :federal_board]].each do |role, group|
      context "with #{role.sti_name} role" do
        let(:user) { Fabricate(role.name.to_sym, group: groups(group)).person }

        it 'contains only current and upcoming camps' do
          get :all_camps
          is_expected.to eq([current, upcoming_in_range])
          is_expected.to_not include(upcoming_outside_range, past)
        end

        it 'via list_camps' do
          expect(get :index).to redirect_to(list_all_camps_path)
        end
      end
    end

    context 'with other role' do
      let(:user) { people(:child) }

      it 'is not allowed' do
        expect { get :all_camps }.to raise_error(CanCan::AccessDenied)
      end

      it 'is not allowed via list_camp' do
        expect { get :index }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'GET state_camps' do
    let(:state) { groups(:be) }
    let(:flock_in_state) { groups(:thun) }
    let(:flock_outside_state) { groups(:ausserroden) }

    let!(:current) do
      Fabricate(:camp,
                groups: [flock_in_state],
                dates: [Fabricate(:event_date, start_at: 15.days.ago, finish_at: 10.days.ago),
                        Fabricate(:event_date, start_at: 5.days.ago, finish_at: 5.days.from_now)])
    end

    let!(:outside_state) do
      Fabricate(:camp,
                groups: [flock_outside_state],
                dates: [Fabricate(:event_date, start_at: 15.days.ago, finish_at: 10.days.ago),
                        Fabricate(:event_date, start_at: 5.days.ago, finish_at: 5.days.from_now)])
    end

    let!(:upcoming_in_year) do
      Fabricate(:camp,
                groups: [flock_in_state],
                dates: [Fabricate(:event_date, start_at: Time.zone.now.end_of_year, finish_at: nil)])
    end

    let!(:upcoming_outside_year) do
      Fabricate(:camp,
                groups: [flock_in_state],
                dates: [Fabricate(:event_date, start_at: 1.year.from_now, finish_at: nil)])
    end

    let!(:past_in_year) do
      Fabricate(:camp,
                groups: [flock_in_state],
                dates: [Fabricate(:event_date, start_at: Time.zone.now.beginning_of_year, finish_at: nil)])
    end

    let!(:past_outside_year) do
      Fabricate(:camp,
                groups: [flock_in_state],
                dates: [Fabricate(:event_date, start_at: 1.year.ago, finish_at: nil)])
    end

    [[Group::State::Coach, :be],
     [Group::State::GroupAdmin, :be],
     [Group::StateAgency::Leader, :be_agency],
     [Group::StateAgency::GroupAdmin, :be_agency]].each do |role, group|
       context "with #{role.sti_name} role" do
         let(:user) { Fabricate(role.name.to_sym, group: groups(group)).person }

         it 'contains only current and upcoming camps' do
           get :state_camps, params: { group_id: state.id }
           is_expected.to contain_exactly(current, upcoming_in_year, past_in_year)
           is_expected.to_not include(upcoming_outside_year, past_outside_year, outside_state)
         end

         it 'via list_camps' do
           expect(get :index).to redirect_to(list_state_camps_path(group_id: groups(:be).id))
         end
       end
     end

    context 'with other role' do
      let(:user) { people(:child) }

      it 'is not allowed' do
        expect { get :all_camps }.to raise_error(CanCan::AccessDenied)
      end

      it 'is not allowed via list_camp' do
        expect { get :index }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
end
