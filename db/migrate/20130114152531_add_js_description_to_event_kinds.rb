# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class AddJsDescriptionToEventKinds < ActiveRecord::Migration[4.2]
  def change
    add_column :event_kinds, :j_s_description, :string
  end
end
