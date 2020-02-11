# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class CreateCensus < ActiveRecord::Migration[4.2]
  def change
    create_table :censuses do |t|
      t.integer :year, null: false
      t.date    :start_at
      t.date    :finish_at
    end

    add_index :censuses, :year, unique: true

    create_table :member_counts do |t|
      t.integer :state_id, null: false
      t.integer :flock_id, null: false
      t.integer :year, null: false
      t.integer :born_in
      t.integer :leader_f
      t.integer :leader_m
      t.integer :child_f
      t.integer :child_m
    end

    add_index :member_counts, [:state_id, :year]
    add_index :member_counts, [:flock_id, :year]
  end
end
