# encoding: utf-8

#  Copyright (c) 2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Jubla::Person::Filter::List do

  let(:person)        { people(:top_leader) }
  let(:alumnus_group) { groups(:bern_ehemalige) }

  %w(ch be city bern).zip(%w(federation state region flock)).each do |group, level|
    let(:alumnus) { Fabricate(Group::FlockAlumnusGroup::Member.name, group: alumnus_group) }

    it 'does not find alumnus role when flag ist not set' do
      alumnus.person.update("contactable_by_#{level}" => false)
      filter = list_filter(group, Group::FlockAlumnusGroup::Member)
      expect(filter.entries).to be_empty
    end

    it 'finds alumnus role only if corresponding flag is set' do
      alumnus.person.update("contactable_by_#{level}" => true)
      filter = list_filter(group, Group::FlockAlumnusGroup::Member)
      expect(filter.entries).to include(alumnus.person)
    end

    it 'ignores flag when other role matches' do
      alumnus.person.update("contactable_by_#{level}" => false)
      Fabricate(Group::Flock::Leader.name, group: groups(:bern), person: alumnus.person)
      filter = list_filter(group, Group::FlockAlumnusGroup::Member, Group::Flock::Leader)
      expect(filter.entries).to include(alumnus.person)
    end

  end

  def list_filter(group, *roles)
    Person::Filter::List.new(groups(group), people(:top_leader), build_params(roles))
  end

  def build_params(roles)
    { range: 'deep',
      filters: {
        role: { role_type_ids: roles.collect(&:id).join('-') }
      }
    }
  end

end
