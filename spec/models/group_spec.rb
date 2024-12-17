#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe Group do
  include_examples "group types"

  describe Group::Federation do
    subject { Group::Federation }

    it { is_expected.to have(7).possible_children }
    it { is_expected.to have(3).default_children }
    it { is_expected.to have(5).role_types }
    it { is_expected.to be_layer }

    its(:possible_children) { is_expected.to include(Group::SimpleGroup) }
  end

  describe Group::Flock do
    subject { Group::Flock }

    it { is_expected.to have(3).possible_children }
    it { is_expected.to have(1).default_children }
    it { is_expected.to have(11).role_types }
    it { is_expected.to be_layer }

    it "may have same name as other flock with different kind" do
      parent = groups(:city)
      flock = Group::Flock.new(name: "bla", kind: "Jungwacht")
      flock.parent = parent
      flock.save!
      other = Group::Flock.new(name: "bla", kind: "Blauring")
      other.parent = parent
      other.valid?
      expect(other.errors.full_messages).to eq([])
    end
  end

  describe Group::SimpleGroup do
    subject { Group::SimpleGroup }

    it { is_expected.to have(1).possible_children }
    it { is_expected.to have(0).default_children }
    it { is_expected.to have(6).role_types }
    it { is_expected.not_to be_layer }
    its(:possible_children) { is_expected.to include(Group::SimpleGroup) }

    it "includes the common roles" do
      expect(subject.role_types).to include(Group::SimpleGroup::GroupAdmin)
    end

    it "includes the external role" do
      expect(subject.role_types).to include(Group::SimpleGroup::External)
    end

    it "may have same name as other group with different parent" do
      flock = Group::SimpleGroup.new(name: "bla")
      flock.parent = groups(:city)
      flock.save!
      other = Group::SimpleGroup.new(name: "bla")
      other.parent = groups(:bern)
      expect(other).to be_valid
    end
  end

  describe "#all_types" do
    subject { Group.all_types }

    it "must have root as the first item" do
      expect(subject.first).to eq(Group::Root)
    end

    it "must have NEJB simple group as last item" do
      expect(subject.last).to eq(Group::NejbSimpleGroup)
    end

    context "#destroy" do
      it "deletes Layer if there are only Alumnus Group childs" do
        group = Group::Region.all.first
        group.children.delete_all
        alumnus_group = Group::RegionalAlumnusGroup.create(name: "test_group", parent_id: group.id)
        alumnus_group2 = Group::RegionalAlumnusGroup.create(name: "test_group2",
          parent_id: group.id)
        alumnus_group3 = Group::RegionalAlumnusGroup.create(name: "test_group3",
          parent_id: alumnus_group2.id)

        expect(group.destroy).not_to be false

        expect(Group.without_deleted.where(id: group.id)).not_to exist
        expect(Group.without_deleted.where(id: alumnus_group.id)).not_to exist
        expect(Group.without_deleted.where(id: alumnus_group2.id)).not_to exist
        expect(Group.without_deleted.where(id: alumnus_group3.id)).not_to exist
      end

      it "deletes all alumnus roles when deleting an alumnus group via its layer" do
        group = Group::Region.all.first
        group.children.delete_all
        alumnus_group = Group::RegionalAlumnusGroup.create(name: "test_group", parent_id: group.id)
        Group::RegionalAlumnusGroup::Member.create!(group: alumnus_group, person: Fabricate(:person))

        expect(Role.with_inactive.where.not(group_id: Group.with_deleted.select(:id)).count).to be 0

        expect { group.destroy }.not_to change { Role.with_inactive.where.not(group_id: Group.with_deleted.select(:id)).count }
      end
    end
  end

  describe ".course_offerers" do
    subject { Group.course_offerers }

    it "includes federation" do
      is_expected.to include groups(:ch)
    end

    it "includes states" do
      is_expected.to include groups(:be)
      is_expected.to include groups(:no)
    end

    it "does not include flocks" do
      is_expected.not_to include groups(:thun)
      is_expected.not_to include groups(:ausserroden)
      is_expected.not_to include groups(:innerroden)
      is_expected.not_to include groups(:bern)
      is_expected.not_to include groups(:muri)
    end

    it "orders by parent and name" do
      expected = ["Jubla Schweiz", "Kanton Bern", "Nordostschweiz"]
      expect(subject.map(&:name)).to eq expected
    end
  end

  describe "alumnus filter" do
    let(:group) { groups(:ch) }

    it "creating non alumnus group creats alumnus filter" do
      expect do
        board = Group::FederalBoard.create(name: "board", parent_id: group.id)
        filter = board.people_filters.find_by(name: "Austritte")
        expect(filter.filter_chain).to be_present
      end.to change { PeopleFilter.count }.by(1)
    end

    it "creating alumnus group does not create alumnus filter" do
      expect do
        Group::FederalAlumnusGroup.create(name: "board", parent_id: group.id)
      end.not_to change { PeopleFilter.count }
    end
  end
end
