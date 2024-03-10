# encoding: utf-8

#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class AddMultipleChoiceToEventQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column(:event_questions, :multiple_choice, :boolean, null: false, default: false)
  end
end
