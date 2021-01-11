# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# delete all default event questions first
Event::Question.where(event_id: nil).destroy_all

# recreate default event questions
[
  {question: 'Ich habe während dem Kurs folgendes ÖV Abo',
   choices: 'GA, Halbtax / unter 16, keine Vergünstigung'},

  {question: 'Ich bin Vegetarier/in',
   choices: 'ja, nein'},

  {question: 'Ich habe bereits das neue Kurshilfsmittel «schub» (Auflage 2016)',
   choices: 'ja, nein'},

  {question: 'Ich habe bereits ein Meisterwerk (das Handbuch der Mindestkenntnisse)',
   choices: 'ja, nein'},
].each do |attrs|
  eq = Event::Question.find_or_initialize_by(
    event_id: attrs.delete(:event_id),
    question: attrs.delete(:question),
  )
  eq.attributes = attrs
  eq.save!
end
