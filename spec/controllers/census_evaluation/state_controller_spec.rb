# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'
require_relative 'subgroups_shared_examples'

describe CensusEvaluation::StateController do

  let(:ch)   { groups(:ch) }
  let(:be)   { groups(:be) }
  let(:bern) { groups(:bern) }
  let(:thun) { groups(:thun) }
  let(:muri) { groups(:muri) }

  before { sign_in(people(:top_leader)) }

  describe 'GET index' do
    before { get :index, id: be.id }

    it 'assigns counts' do
      counts = assigns(:group_counts)
      counts.keys.should =~ [bern.id, thun.id]
      counts[bern.id].total.should == 12
      counts[thun.id].total.should == 7
    end

    it 'assigns total' do
      assigns(:total).should be_kind_of(MemberCount)
    end

    it 'assigns sub groups' do
      assigns(:sub_groups).should == [bern, groups(:muri), thun]
    end

    it 'assigns details' do
      details = assigns(:details).to_a
      details.should have(5).items

      details[0].born_in.should == 1984
      details[1].born_in.should == 1985
      details[2].born_in.should == 1988
      details[3].born_in.should == 1997
      details[4].born_in.should == 1999
    end
  end

  describe 'POST remind' do
    it 'creates mail job' do
      expect { post :remind, id: be.id, flock_id: bern.id, format: :js }.to change { Delayed::Job.count }.by(1)
    end

    context '.js' do
      before { post :remind, id: be.id, flock_id: bern.id, format: :js }

      it 'renders update_flash' do
        should render_template('census_evaluation/state/remind')
      end

      it 'sets flash messages' do
        flash[:notice].should =~ /an Jungwacht Bern geschickt/
      end
    end

    it 'redirects flock leaders' do
      sign_in(people(:flock_leader))
      expect do
        expect { post :remind, id: be.id, flock_id: bern.id, format: :js }.to raise_error(CanCan::AccessDenied)
      end.not_to change { Delayed::Job.count }
    end
  end

  it_behaves_like 'sub_groups' do
    let(:parent)              { be }
    let(:census)              { censuses(:two_o_12) }
    let(:subgroups)           { [bern, muri, thun] }
    let(:group_to_delete)     { bern }
    let(:group_without_count) { muri }

    context 'when moving group' do
      let(:target) { be }
      let(:innerroden)  { groups(:innerroden) }

      before do
        Fabricate(:member_count, year: census.year, flock: groups(:innerroden), state: groups(:no))
        Group::Mover.new(innerroden).perform(target)
      end

      context 'in new parent' do
        include_examples 'sub_groups_examples' do
          let(:current_census_groups) { subgroups + [innerroden] }
          let(:past_census_groups)    { subgroups - [group_without_count] } # count written for old group
          let(:future_census_groups)  { subgroups + [innerroden] }
        end
      end

      context 'old parent' do
        let(:parent)          { groups(:no) }
        let(:ausserroden)     { groups(:ausserroden) }

        include_examples 'sub_groups_examples' do
          let(:current_census_groups) { [ausserroden] }
          let(:past_census_groups)    { [innerroden] }
          let(:future_census_groups)  { [ausserroden] }
        end
      end
    end
  end
end
