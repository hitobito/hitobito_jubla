# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

Event::Question.seed(:event_id, :question,
  {question: 'Ich habe während dem Kurs folgendes ÖV Abo',
   choices: 'GA, Halbtax / unter 16, keine Vergünstigung'},

  {question: 'Ich bin Vegetarier',
   choices: 'ja, nein'},

  {question: 'Ich habe bereits den Schub (das Werkbuch für Leiterinnen und Leiter der Jubla)',
   choices: 'ja, nein'},
)
