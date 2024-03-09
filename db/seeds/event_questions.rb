# encoding: utf-8

#  Copyright (c) 2012-2023, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# delete all default event questions first
Event::Question.where(event_id: nil).destroy_all

# recreate default event questions
[
  {question: 'Ich habe während dem Kurs folgendes ÖV Abo',
   choices: 'GA, Halbtax / unter 16, keine Vergünstigung'},

  {question: 'Ich habe folgende Essgewohnheiten/Allergien',
   choices: 'Nichts Spezielles, Vegetarisch, Vegan, Glutenfrei, Laktosefrei'},

  {question: 'Den schub (Ordner mit fünf schub-Broschüren, digital unter www.jubla.ch/schub)...',
   choices: 'besitze ich und nehme ich mit, leihe ich von jemandem aus, habe ich nicht/kann ich nicht ausleihen/möchte ich als eigenen analogen Ordner'},

  {question: 'Das meisterwerk (Handbuch der Mindestkenntnisse Jubla-Technik, digital unter www.jubla.ch/jublatechnik)...',
   choices: 'besitze ich und nehme ich mit, leihe ich von jemandem aus, habe ich nicht/kann ich nicht ausleihen/möchte ich als eigenes analoges Handbuch'},
].each do |attrs|
  eq = Event::Question.find_or_initialize_by(
    event_id: attrs.delete(:event_id),
    question: attrs.delete(:question),
    required: true,
  )
  eq.attributes = attrs
  eq.save!
end
