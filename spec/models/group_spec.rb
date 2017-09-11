# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Group do

  include_examples 'group types'


  describe Group::Federation do
    subject { Group::Federation }

    it { is_expected.to have(7).possible_children }
    it { is_expected.to have(3).default_children }
    it { is_expected.to have(4).role_types }
    it { is_expected.to be_layer }

    its(:possible_children) { should include(Group::SimpleGroup) }
  end

  describe Group::Flock do
    subject { Group::Flock }

    it { is_expected.to have(3).possible_children }
    it { is_expected.to have(1).default_children }
    it { is_expected.to have(11).role_types }
    it { is_expected.to be_layer }

    it 'may have same name as other flock with different kind' do
      parent = groups(:city)
      flock = Group::Flock.new(name: 'bla', kind: 'Jungwacht')
      flock.parent = parent
      flock.save!
      other = Group::Flock.new(name: 'bla', kind: 'Blauring')
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
    its(:possible_children) { should include(Group::SimpleGroup) }

    it 'includes the common roles' do
      expect(subject.role_types).to include(Group::SimpleGroup::GroupAdmin)
    end

    it 'includes the external role' do
      expect(subject.role_types).to include(Group::SimpleGroup::External)
    end

    it 'may have same name as other group with different parent' do
      flock = Group::SimpleGroup.new(name: 'bla')
      flock.parent = groups(:city)
      flock.save!
      other = Group::SimpleGroup.new(name: 'bla')
      other.parent = groups(:bern)
      expect(other).to be_valid
    end

  end

  describe '#all_types' do
    subject { Group.all_types }

    it 'must have root as the first item' do
      expect(subject.first).to eq(Group::Federation)
    end

    it 'must have simple group as last item' do
      expect(subject.last).to eq(Group::SimpleGroup)
    end

    context '#destroy' do
      it 'deletes Layer if there are only Alumnus Group childs' do
        group = Group::Region.all.first
        group.children.delete_all
        alumnus_group = Group::RegionalAlumnusGroup.create(name: 'test_group', parent_id: group.id)
        alumnus_group2 = Group::RegionalAlumnusGroup.create(name: 'test_group2',
                                                            parent_id: group.id)
        alumnus_group3 = Group::RegionalAlumnusGroup.create(name: 'test_group3',
                                                            parent_id: alumnus_group2.id)

        expect(group.destroy).not_to be false

        expect(Group.without_deleted.where(id: group.id)).not_to exist
        expect(Group.without_deleted.where(id: alumnus_group.id)).not_to exist
        expect(Group.without_deleted.where(id: alumnus_group2.id)).not_to exist
        expect(Group.without_deleted.where(id: alumnus_group3.id)).not_to exist
      end
    end
  end

  describe '.course_offerers' do
    subject { Group.course_offerers }

    it 'includes federation' do
      is_expected.to include groups(:ch)
    end

    it 'includes states' do
      is_expected.to include groups(:be)
      is_expected.to include groups(:no)
    end

    it 'does not include flocks' do
      is_expected.not_to include groups(:thun)
      is_expected.not_to include groups(:ausserroden)
      is_expected.not_to include groups(:innerroden)
      is_expected.not_to include groups(:bern)
      is_expected.not_to include groups(:muri)
    end

    it 'orders by parent and name' do
      expected = ['Jubla Schweiz', 'Kanton Bern', 'Nordostschweiz']
      expect(subject.map(&:name)).to eq expected
    end
  end

end
