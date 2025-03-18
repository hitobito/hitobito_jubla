# encoding: utf-8

#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
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

Event::Question.seed_global({
  question: 'Den schub (Ordner mit fünf schub-Broschüren, digital unter jubla.ch/schub)...',
  choices: 'habe ich bereits und nehme ihn mit in den Kurs, leihe ich von jmd aus und nehme ihn mit in den Kurs (je neuer die Auflage desto besser), habe ich nicht/leihe ich nicht aus: bestelle ich hiermit als Ordner (Kosten: CHF 27.-)',
  disclosure: :required,
  event_type: Event::Course.sti_name,
  multiple_choices: false
})

Event::Question.seed_global({
  question: 'Das meisterwerk (Handbuch der Mindestkenntnisse Jubla-Technik, digital unter jubla.ch/jublatechnik)...',
  choices: 'besitze ich bereits und nehme es mit in den Kurs (Auflage ab 2017), leihe ich von jemandem aus der Schar aus und nehme es mit in den Kurs (Auflage ab 2017), habe ich nicht und hätte es gerne als eigenes analoges Handbuch (ohne Kosten)',
  disclosure: :required,
  event_type: Event::Course.sti_name,
  multiple_choices: false
})