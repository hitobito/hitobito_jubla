# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'csv'

module Event::Course::BsvInfo

  class List < Export::Csv::Base

    FIELDS = { vereinbarung_id_fiver: 'Vereinbarung-ID-FiVer',
               kurs_id_fiver: 'Kurs-ID-FiVer',
               number: 'Kursnummer',
               date: 'Datum',
               location: 'Kursort',
               training_days: 'Ausbildungstage',
               participants: 'Teilnehmende (17-30)',
               leaders: 'Kursleitende',
               cantons: 'Wohnkantone der TN',
               languages: 'Sprachen',
               total_days: 'Kurstage',
               participants_total: 'Teilnehmende Total',
               leaders_total: 'Leitungsteam Total',
               cooks: 'Küchenteam',
               speakers: 'Referenten' }


    def to_csv(generator)
      generator << FIELDS.values

      list.each do |entry|
        info = Event::Course::BsvInfo::Row.new(entry)
        generator << FIELDS.keys.map { |key| info.send(key) }
      end
    end
  end
end
