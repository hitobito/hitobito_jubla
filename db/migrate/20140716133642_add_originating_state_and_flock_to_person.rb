# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class AddOriginatingStateAndFlockToPerson < ActiveRecord::Migration
  attr_reader :people, :flocks, :states

  def change
    add_column(:people, :originating_state_id, :integer)
    add_column(:people, :originating_flock_id, :integer)

    say_with_time("loading people") { load_people }

    say_with_time("compute origins") { compute_origins }
    say_with_time("writing origins") { write_origins }
  end

  private

  def load_people
    groups = GroupOriginator::FLOCK_ROLES + GroupOriginator::STATE_ROLES
    @people = Person.
      includes(:roles).
      where(roles: { type: groups } )
    say("loaded #{people.size} people")
  end

  def compute_origins
    @flocks = Hash.new {|k,v| k[v] = [] }
    @states = Hash.new {|k,v| k[v] = [] }

    people.each do |person|
      hash = GroupOriginator.new(person).to_h
      flock_id = hash[:originating_flock_id]
      state_id = hash[:originating_state_id]

      flocks[flock_id] << person.id if flock_id
      states[state_id] << person.id if state_id
    end
  end

  def write_origins
    flocks.each do |flock_id, people_ids|
      Person.where(id: people_ids).update_all(originating_flock_id: flock_id)
    end

    states.each do |state_id, people_ids|
      Person.where(id: people_ids).update_all(originating_state_id: state_id)
    end
  end
end
