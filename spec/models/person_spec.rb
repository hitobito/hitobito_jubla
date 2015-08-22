
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
    expect(Person.new(zip_code: 3000).canton).to eq 'BE'
    expect(Person.new(zip_code: 3000, canton: 'ZH').canton).to eq('ZH')
  end

  def create(*roles)
    roles.map do |role_class, group|
      Fabricate(role_class.name, group: group, person: person)
    end
  end
end
