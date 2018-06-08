
# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Person do

  let(:person) { Fabricate(:person) }

  context 'origin' do

    before do
      @bern, @innerroden = create([Group::Flock::Leader, groups(:bern)],
                                  [Group::Flock::Leader, groups(:innerroden)])
    end

    it 'has origin flock and state for newly created roles' do
      expect(person.reload.originating_flock).to be_present
      expect(person.reload.originating_state).to be_present
    end

    it 'has updated origins when destroying roles' do
      @innerroden.really_destroy!

      expect(person.reload.originating_flock).to eq groups(:bern)
      expect(person.reload.originating_state).to eq groups(:be)
    end

    it 'has updated origins when updating roles' do
      @bern.update_attribute(:label, 'test')

      expect(person.reload.originating_flock).to eq groups(:bern)
      expect(person.reload.originating_state).to eq groups(:be)
    end

    it 'displays flock kind for role group' do
      p = Person.preload_groups.find_by_id(person.id)
      names = p.roles.collect { |r| r.group.to_s }
      expect(names).to match_array(['Jungwacht Bern', 'Jubla Innerroden'])
    end

    def create(*roles)
      roles.map do |role_class, group|
        Fabricate(role_class.name, group: group, person: person)
      end
    end
  end

  it 'maps canton via location if zip_code is present' do
    expect(Person.new(zip_code: 3000).canton).to eq 'be'
    expect(Person.new(zip_code: 3000, canton: 'zh').canton).to eq('zh')
  end

  context 'alumnus_only' do
    it 'does not find person without roles' do
      expect(Person.alumnus_only).not_to include(person)
      expect(person).not_to be_alumnus_only
    end

    it 'does find person with alumnus role' do
      Fabricate(Group::Flock::Alumnus.sti_name, group: groups(:bern), person: person)
      expect(Person.alumnus_only).to include(person)
      expect(person).to be_alumnus_only
    end

    it 'does find person with alumnus member role' do
      Fabricate(Group::FlockAlumnusGroup::Member.sti_name, group: groups(:bern_ehemalige), person: person)
      expect(Person.alumnus_only).to include(person)
      expect(person).to be_alumnus_only
    end

    it 'does not find person with alumnus role and active role' do
      Fabricate(Group::Flock::Alumnus.sti_name, group: groups(:bern), person: person)
      Fabricate(Group::Flock::Leader.sti_name, group: groups(:bern), person: person)
      expect(Person.alumnus_only).not_to include(person)
      expect(person).not_to be_alumnus_only
    end
  end

end
