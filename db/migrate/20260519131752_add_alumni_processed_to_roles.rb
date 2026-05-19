# frozen_string_literal: true

# Copyright (c) 2026, Jubla. This file is part of
# hitobito_pbs and licensed under the Affero General Public License version 3
# or later. See the COPYING file at the top-level directory or at
# https://github.com/hitobito/hitobito_jubla.

class AddAlumniProcessedToRoles < ActiveRecord::Migration[8.0]
  def change
    add_column(:roles, :alumni_processed, :boolean, default: false, null: false)
  end
end
