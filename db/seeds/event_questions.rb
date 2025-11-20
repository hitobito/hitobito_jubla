# encoding: utf-8

#  Copyright (c) 2012-2025, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

Event::Question.seed_global({
  question: 'Ich habe während dem Kurs folgendes ÖV Abo',
  choices: 'GA, Halbtax / unter 16, keine Vergünstigung',
  disclosure: :required,
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