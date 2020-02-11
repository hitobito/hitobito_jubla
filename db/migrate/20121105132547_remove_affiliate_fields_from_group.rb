# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class RemoveAffiliateFieldsFromGroup < ActiveRecord::Migration[4.2]
  def up
    remove_column :groups, :coach_id
    remove_column :groups, :advisor_id
  end

  def down
    add_column :groups, :coach_id, :integer
    add_column :groups, :advisor_id, :integer
  end
end
