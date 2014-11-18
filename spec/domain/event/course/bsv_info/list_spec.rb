# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Event::Course::BsvInfo::List do
  let(:course) { events(:top_course) }

  context 'export' do
    let(:lines) { Event::Course::BsvInfo::List.export([course, course]).split("\n") }
    let(:headers) {  lines.first.encode('UTF-8').split(';') }

    it 'exports headers' do
      headers.should eq ["Vereinbarung-ID-FiVer", "Kurs-ID-FiVer", "Kursnummer", "Datum", "Kursort", "Ausbildungstage",
                         "Teilnehmende (17-30)", "Kursleitende", "Wohnkantone der TN", "Sprachen", "Kurstage",
                         "Teilnehmende Total", "Leitungsteam Total", "Küchenteam", "Referenten"]
    end

    it 'exports semicolon separted list' do
      lines[1].should eq ";;;01.03.2012;;;0;1;0;;9;1;1;0;0"
      lines[2].should eq ";;;01.03.2012;;;0;1;0;;9;1;1;0;0"
    end
  end

end
