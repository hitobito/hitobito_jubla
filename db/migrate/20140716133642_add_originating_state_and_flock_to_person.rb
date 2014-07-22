# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class AddOriginatingStateAndFlockToPerson < ActiveRecord::Migration
  def change
    add_column(:people, :originating_state_id, :integer)
    add_column(:people, :originating_flock_id, :integer)
    say_with_time "Updating #{Person.count} People ..." do
      Person.includes(:roles).to_a.each { |person| person.update_columns(GroupOriginator.new(person).to_h) }
    end
  end
end
