
# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Person do

  let(:person) { Fabricate(:person) }

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

  it 'maps canton via location if zip_code is present' do
    expect(Person.new(zip_code: 3000).canton).to eq 'be'
    expect(Person.new(zip_code: 3000, canton: 'zh').canton).to eq('zh')
  end

  it 'displays flock kind for role group' do
    p = Person.preload_groups.find_by_id(person.id)
    names = p.roles.collect { |r| r.group.to_s }
    expect(names).to match_array(['Jungwacht Bern', 'Jubla Innerroden'])
  end

  context 'person has participation' do

    let(:participant) { people(:top_leader) }
    let(:participation) { Fabricate(:event_participation, person: participant) }
    let(:user) { participant }
    let(:event) { participation.event }
    let(:group) { event.groups.first }
    
    it 'check for participation' do
      expect(user.signed_in?(event,user,event.id)).to eq(true)
    end

  end

  def create(*roles)
    roles.map do |role_class, group|
      Fabricate(role_class.name, group: group, person: person)
    end
  end
end
