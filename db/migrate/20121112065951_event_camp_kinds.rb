# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class EventCampKinds < ActiveRecord::Migration

  def change
    create_table :event_camp_kinds do |t|
      t.string :label
      t.datetime :deleted_at
      t.timestamps null: true
    end
  end

end
