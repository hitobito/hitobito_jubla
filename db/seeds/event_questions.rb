# encoding: utf-8

#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# delete all default event questions first
Event::Question.where(event_id: nil).destroy_all

# recreate default event questions
questions_data = [
  { question: 'Ich habe während dem Kurs folgendes ÖV Abo',
    choices: 'GA, Halbtax / unter 16, keine Vergünstigung',
    disclosure: :required,
    multiple_choices: false },

  { question: 'Ich habe folgende Essgewohnheiten/Allergien',
    choices: 'Nichts Spezielles, Vegetarisch, Vegan, Glutenfrei, Laktosefrei',
    disclosure: :optional,
    multiple_choices: true },

  { question: 'Den schub (Ordner mit fünf schub-Broschüren, digital unter jubla.ch/schub)...',
    choices: 'hab ich bereits und nehme ihn mit in den Kurs, leihe ich von jmd aus und nehme ihn mit in den Kurs (je neuer die Auflage desto besser), habe ich nicht/leihe ich nicht aus, bestelle ich hiermit als Ordner (Kosten: CHF 27.-)',
    event_type: 'Event::Course',
    disclosure: :required,
    multiple_choices: false },

  { question: 'Das meisterwerk (Handbuch der Mindestkenntnisse Jubla-Technik, digital unter jubla.ch/jublatechnik)...',
    choices: 'besitze ich bereits und nehme es mit in den Kurs (Auflage ab 2017), leihe ich von jemandem aus der Schar aus und nehme es mit in den Kurs (Auflage ab 2017), habe ich nicht und hätte es gerne als eigenes analoges Handbuch (ohne Kosten)',
    disclosure: :required,
    multiple_choices: false },
]

questions_data.each do |attrs|
  eq = Event::Question.find_or_initialize_by(
    event_id: attrs.delete(:event_id),
    question: attrs.delete(:question)
  )
  eq.attributes = attrs
  eq.save!
end