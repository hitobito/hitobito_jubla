# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe GroupOriginator do

  let(:person) { Fabricate(:person) }
  let(:originator) { GroupOriginator.new(person) }

  def create(*roles)
    roles.each do |role_class, group, attrs|
      role = Fabricate(role_class.name, group: group, person: person)
      role.update_columns(attrs) if attrs
    end
  end

  def assert_originating_groups(attrs)
    [:flock, :state].each do |group|
      expect(originator.send(group)).to eq attrs[group]
    end
  end

  context 'flock' do
    it 'deleted are considered' do
      create([Group::Flock::Leader, groups(:bern), created_at: 2.days.ago, deleted_at: 1.day.ago])
      assert_originating_groups flock: groups(:bern), state: groups(:be)
    end

    it 'active are more important than deleted' do
      create([Group::Flock::Leader, groups(:bern), created_at: 2.days.ago, deleted_at: 1.day.ago],
             [Group::Flock::Leader, groups(:innerroden), updated_at: 2.day.ago])
      assert_originating_groups flock: groups(:innerroden), state: groups(:no)
    end

    it 'most recent updated_at wins' do
      create([Group::Flock::Leader, groups(:innerroden), updated_at: 5.days.ago],
             [Group::Flock::Leader, groups(:bern)])
      assert_originating_groups flock: groups(:bern), state: groups(:be)
    end

    it 'flock takes precendence over childgroup' do
      create([Group::Flock::Leader, groups(:innerroden), updated_at: 5.days.ago],
             [Group::ChildGroup::Child, groups(:asterix)])
      assert_originating_groups flock: groups(:innerroden), state: groups(:no)
    end

    it 'active childgroup overrides deleted flock' do
      create([Group::Flock::Leader, groups(:innerroden), created_at: 2.weeks.ago, deleted_at: 5.days.ago],
             [Group::ChildGroup::Child, groups(:asterix)])
      assert_originating_groups flock: groups(:bern), state: groups(:be)
    end

    GroupOriginator::FLOCK_ROLES.each do |role|
      it "sets originating groups for #{role}" do
        create([role, groups(:bern)])
        assert_originating_groups flock: groups(:bern), state: groups(:be)
      end
    end

    Group::ChildGroup.roles.each do |role|
      it "sets originating groups for #{role}" do
        create([role, groups(:asterix)])
        assert_originating_groups flock: groups(:bern), state: groups(:be)
      end
    end
  end

  context 'without flock' do
    it 'deleted are considered' do
      create([Group::StateBoard::Leader, groups(:be_board), created_at: 2.days.ago, deleted_at: 1.day.ago])
      assert_originating_groups state: groups(:be)
    end

    it 'active are more important than deleted' do
      create([Group::StateBoard::Leader, groups(:be_board), created_at: 2.days.ago, deleted_at: 1.day.ago],
             [Group::StateBoard::Leader, groups(:no_board), updated_at: 2.day.ago])
      assert_originating_groups state: groups(:no)
    end

    it 'most recent updated_at wins' do
      create([Group::StateBoard::Leader, groups(:be_board), updated_at: 3.day.ago],
             [Group::StateBoard::Leader, groups(:no_board)])
      assert_originating_groups state: groups(:no)
    end

    it 'board does not take precendence over agency' do
      create([Group::StateBoard::Leader, groups(:no_board), updated_at: 5.days.ago],
             [Group::StateAgency::Leader, groups(:be_agency)])
      assert_originating_groups state: groups(:be)
    end

    (GroupOriginator::STATE_ROLES - [Group::StateAgency::Leader]).each do |role|
      it "sets originating groups for #{role}" do
        create([role, groups(:be_board)])
        assert_originating_groups state: groups(:be)
      end
    end
    it "sets originating groups for Group::StateAgency::Leader" do
      create([Group::StateAgency::Leader, groups(:be_agency)])
      assert_originating_groups state: groups(:be)
    end
  end

  context 'ignored' do
    (Group::Flock.roles - GroupOriginator::FLOCK_ROLES).each do |role|
      it "ignores #{role}" do
        create([role, groups(:bern)])
        assert_originating_groups flock: nil, state: nil
      end
    end

    (Group::StateBoard.roles - GroupOriginator::STATE_ROLES).each do |role|
      it "ignores #{role}" do
        create([role, groups(:be_board)])
        assert_originating_groups flock: nil, state: nil
      end
    end

    (Group::StateAgency.roles - [Group::StateAgency::Leader]).each do |role|
      it "ignores #{role}" do
        create([role, groups(:be_agency)])
        assert_originating_groups flock: nil, state: nil
      end
    end
  end

end
