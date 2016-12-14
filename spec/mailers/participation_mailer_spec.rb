# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Jubla::Event::ParticipationMailer do

  before do
    SeedFu.quiet = true
    SeedFu.seed [Rails.root.join('db', 'seeds')]
  end

  let(:person) { people(:top_leader) }
  let(:event) { Fabricate(:event) }
  let(:participation) { Fabricate(:event_participation, event: event, person: person) }
  let(:mail) { Event::ParticipationMailer.unparticipate(event, person) }

  subject { mail.body }

  before do
    Fabricate(:phone_number, contactable: person, public: true)
  end

  describe 'event data' do

    it 'renders dates if set' do
      event.dates.clear
      event.dates.build(label: 'Vorweekend', start_at: Date.parse('2012-10-18'), finish_at: Date.parse('2012-10-21'))
      is_expected.to match(/Daten:<br\/>Vorweekend: 18.10.2012 - 21.10.2012/)
    end

    it 'renders multiple dates below each other' do
      event.dates.clear
      event.dates.build(label: 'Vorweekend', start_at: Date.parse('2012-10-18'), finish_at: Date.parse('2012-10-21'))
      event.dates.build(label: 'Anlass', start_at: Date.parse('2012-10-21'))
      is_expected.to match(/Daten:<br\/>Vorweekend: 18.10.2012 - 21.10.2012<br\/>Anlass: 21.10.2012/)
    end

  end

  describe '#unparticipate' do

    it 'renders the headers' do
      expect(mail.subject).to eq 'Bestätigung der Abmeldung'
      expect(mail.to).to eq(['top.leader@jubla.example.com'])
      expect(mail.from).to eq(['noreply@localhost'])
    end

    it { is_expected.to match(/Hallo Top/) }

  end

end
