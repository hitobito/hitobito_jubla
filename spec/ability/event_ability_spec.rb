#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe EventAbility do

  let(:user)    { role.person }
  let(:group)   { groups(:be_board) }
  let(:event)   { Fabricate(:event, groups: [group]) }

  def ability(person)
    Ability.new(person.reload)
  end

  def create(event_role_type, person)
    participation = Fabricate(:event_participation, person: person, event: event)
    Fabricate(event_role_type.name, participation: participation)
  end

  context 'index_participations_details on event in group ' do
    it 'FederalBoard::Member is allowed because of :layer_and_below_full' do
      ability(people(:top_leader)).should be_able_to(:index_participations_details, event)
    end

    it 'State::GroupAdmin is allowed because of :group_full' do
      person = Fabricate(Group::StateBoard::Leader.name, group: group).person
      ability(person).should be_able_to(:index_participations_details, event)
    end

    it 'Flock::Leader with leader role is allowed' do
      person = people(:flock_leader)
      create(Event::Role::Leader, person)

      ability(person).should be_able_to(:index_participations_details, event)
    end

    it 'Flock::Leader with participation role is not allowed' do
      person = people(:flock_leader)
      create(Event::Role::Participant, person)

      ability(person).should_not be_able_to(:index_participations_details, event)
    end
  end

end
