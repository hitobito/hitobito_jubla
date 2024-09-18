# encoding: utf-8

#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

Event::Question.seed_global({
  question: 'Ich habe während dem Kurs folgendes ÖV Abo',
  choices: 'GA, Halbtax / unter 16, keine Vergünstigung',
  disclosure: :optional,
  event_type: Event::Course.sti_name,
  multiple_choices: false
})

Event::Question.seed_global({
  question: 'Ich habe folgende Essgewohnheiten/Allergien',
  choices: 'Nichts Spezielles, Vegetarisch, Vegan, Glutenfrei, Laktosefrei',
  disclosure: :optional,
  event_type: Event::Course.sti_name,
  multiple_choices: true
})

Event::Question.seed_global({
  question: 'Den schub (Ordner mit fünf schub-Broschüren, digital unter www.jubla.ch/schub)...',
  choices: 'besitze ich und nehme ich mit, leihe ich von jemandem aus, habe ich nicht/kann ich nicht ausleihen/möchte ich als eigenen analogen Ordner',
  disclosure: :optional,
  event_type: Event::Course.sti_name,
  multiple_choices: false
})

Event::Question.seed_global({
  question: 'Das meisterwerk (Handbuch der Mindestkenntnisse Jubla-Technik, digital unter www.jubla.ch/jublatechnik)...',
  choices: 'besitze ich und nehme ich mit, leihe ich von jemandem aus, habe ich nicht/kann ich nicht ausleihen/möchte ich als eigenes analoges Handbuch',
  disclosure: :optional,
  event_type: Event::Course.sti_name,
  multiple_choices: false
})
