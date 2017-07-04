# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# delete all default event questions first
Event::Question.where(event_id: nil).destroy_all

# recreate default event questions
Event::Question.seed(:event_id, :question,
  {question: 'Ich habe während dem Kurs folgendes ÖV Abo',
   choices: 'GA, Halbtax / unter 16, keine Vergünstigung'},

  {question: 'Ich bin Vegetarier',
   choices: 'ja, nein'},

  {question: 'Ich habe bereits das neue Kurshilfsmittel «schub» (Auflage 2016)',
   choices: 'ja, nein'},

  {question: 'Ich habe bereits ein Meisterwerk (das Handbuch der Mindestkenntnisse)',
   choices: 'ja, nein'},
)
