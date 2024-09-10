# frozen_string_literal: true

# Copyright (c) 2024, Jubla. This file is part of
# hitobito_pbs and licensed under the Affero General Public License version 3
# or later. See the COPYING file at the top-level directory or at
# https://github.com/hitobito/hitobito_jubla.

class AddEventTypeToExistingGlobalQuestions < ActiveRecord::Migration[6.1]
  def up
    Event::Question.global.update_all(event_type: Event::Course.sti_name)
  end

  def down
  end
end
