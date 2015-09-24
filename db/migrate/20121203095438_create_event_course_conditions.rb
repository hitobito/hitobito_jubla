# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class CreateEventCourseConditions < ActiveRecord::Migration
  def change
    create_table :event_conditions do |t|
      t.integer :group_id
      t.string :label, null: false
      t.text :content, null: false

      t.timestamps null: true
    end

    add_index :event_conditions, [:group_id, :label], :unique => true
    add_column :events, :condition_id, :integer
  end
end
