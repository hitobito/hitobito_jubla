# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe PopulationController do

  let(:flock) { groups(:bern) }
  let(:asterix) { groups(:asterix) }


  let!(:leader) { Fabricate(Group::Flock::Leader.name.to_sym, group: flock).person }
  let!(:guide) { Fabricate(Group::Flock::Guide.name.to_sym, group: flock).person }
  let!(:alumnus) { Fabricate(Group::Flock::Alumnus.name.to_sym, group: flock).person }
  let!(:deleted) { Fabricate(Group::Flock::Leader.name.to_sym, group: flock, deleted_at: 1.year.ago) }
  let!(:group_leader) { Fabricate(Group::ChildGroup::Leader.name.to_sym, group: asterix, person: guide).person }
  let!(:child) { Fabricate(Group::ChildGroup::Child.name.to_sym, group: asterix).person }

  before { sign_in(leader) }

  describe "GET index" do

    before { get :index, id: flock.id }

    describe "groups" do
      subject { assigns(:groups) }

      it { should == [flock, groups(:asterix), groups(:obelix), groups(:fussball)] }
    end

    describe "people by group" do
      subject { assigns(:people_by_group) }

      it { subject[flock].collect(&:to_s).should =~ [leader,people(:flock_leader_bern), guide].collect(&:to_s)}
      it { subject[groups(:asterix)].collect(&:to_s).should =~ [group_leader, child, people(:child)].collect(&:to_s) }
      it { subject[groups(:obelix)].should == [] }
    end

    describe "complete" do
      subject { assigns(:people_data_complete) }

      it { should be_false }
    end
  end

end
