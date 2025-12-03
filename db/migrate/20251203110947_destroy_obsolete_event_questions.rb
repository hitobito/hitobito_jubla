# frozen_string_literal: true

# Copyright (c) 2025, Jubla. This file is part of
# hitobito_pbs and licensed under the Affero General Public License version 3
# or later. See the COPYING file at the top-level directory or at
# https://github.com/hitobito/hitobito_jubla.

class DestroyObsoleteEventQuestions < ActiveRecord::Migration[8.0]
  def up
    [
      'Den schub (Ordner mit fünf schub-Broschüren, digital unter jubla.ch/schub)...',
      'Das meisterwerk (Handbuch der Mindestkenntnisse Jubla-Technik, digital unter jubla.ch/jublatechnik)...'
    ].each do |question|
        Event::Question.find_by(question: , event_id: nil)&.destroy
      end
  end
end
