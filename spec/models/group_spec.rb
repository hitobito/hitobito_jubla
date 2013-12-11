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

    it { should have(6).possible_children }
    it { should have(2).default_children }
    it { should have(4).role_types }
    it { should be_layer }

    its(:possible_children) { should include(Group::SimpleGroup) }
  end

  describe Group::Flock do
    subject { Group::Flock }

    it { should have(2).possible_children }
    it { should have(0).default_children }
    it { should have(11).role_types }
    it { should be_layer }

    it 'may have same name as other flock with different kind' do
      parent = groups(:city)
      flock = Group::Flock.new(name: 'bla', kind: 'Jungwacht')
      flock.parent = parent
      flock.save!
      other = Group::Flock.new(name: 'bla', kind: 'Blauring')
      other.parent = parent
      other.valid?
      other.errors.full_messages.should == []
    end

  end

  describe Group::SimpleGroup do
    subject { Group::SimpleGroup }
    it { should have(1).possible_children }
    it { should have(0).default_children }
    it { should have(6).role_types }
    it { should_not be_layer }
    its(:possible_children) { should include(Group::SimpleGroup) }

    it 'includes the common roles' do
      subject.role_types.should include(Group::SimpleGroup::GroupAdmin)
    end

    it 'includes the external role' do
      subject.role_types.should include(Group::SimpleGroup::External)
    end

    it 'may have same name as other group with different parent' do
      flock = Group::SimpleGroup.new(name: 'bla')
      flock.parent = groups(:city)
      flock.save!
      other = Group::SimpleGroup.new(name: 'bla')
      other.parent = groups(:bern)
      other.should be_valid
    end

  end

  describe '#all_types' do
    subject { Group.all_types }

    it 'must have root as the first item' do
      subject.first.should == Group::Federation
    end

    it 'must have simple group as last item' do
      subject.last.should == Group::SimpleGroup
    end
  end

  describe '.course_offerers' do
    subject { Group.course_offerers }

    it 'includes federation' do
      should include groups(:ch)
    end

    it 'includes states' do
      should include groups(:be)
      should include groups(:no)
    end

    it 'does not include flocks' do
      should_not include groups(:thun)
      should_not include groups(:ausserroden)
      should_not include groups(:innerroden)
      should_not include groups(:bern)
      should_not include groups(:muri)
    end

    it 'orders by parent and name' do
      expected = ['Jubla Schweiz', 'Kanton Bern', 'Nordostschweiz']
      subject.map(&:name).should eq expected
    end
  end

end
