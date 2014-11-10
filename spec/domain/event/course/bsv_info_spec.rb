# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Event::Course::BsvInfo do
  let(:course) { events(:top_course) }
  let(:info) { Event::Course::BsvInfo.new(course.reload) }

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

  it 'info straight form course or kind' do
    course.kind.update_attribute(:bsv_id, 'slk')
    course.update_attributes!(number: 'slk 123', training_days: 3.5,
                              application_contact: course.possible_contact_groups.first)

    info.kurs_id_fiver.should eq 'slk'
    info.number.should eq 'slk 123'
    info.training_days.should eq 3.5
  end

  context 'info from dates' do

    it 'blank if no dates specified' do
      course.dates.destroy_all

      %w(date total_days location).each do |attr|
        info.send(attr.to_sym).should be_blank
      end
    end

    it 'sets date to start_at of first date' do
      info.date.should eq '01.03.2012'
    end

    it 'calculates total from summed date durations' do
      info.total_days.should eq 9
    end

    it 'sets location from date with longest duration' do
      event_dates(:first_two).update_attribute(:location, 'somewhere')
      info.location.should eq 'somewhere'
    end

  end

  context 'info from participations' do

    def create(*role_types)
      roles = role_types.map { |type| Fabricate(:event_role, type: type.name) }
      Fabricate(:event_participation, event: course, roles: roles)
    end

    it 'handles null values' do
      course.participations.destroy_all

      %w(participants participants_total leaders leaders_total cooks speakers).each do |attr|
        info.send(attr.to_sym).should eq 0
      end
    end

    context 'role info' do
      it 'has default roles from fixtures' do
        info.leaders.should eq 1
        info.leaders_total.should eq 1
        info.participants_total.should eq 1

        info.cooks.should eq 0
        info.speakers.should eq 0
      end

      it 'counts participations with mulitple roles only once' do
        create(Event::Role::Leader, Event::Role::Leader, Event::Role::AssistantLeader)

        info.leaders.should eq 2
        info.leaders_total.should eq 2
      end

      it 'does not count Advisor role' do
        create(Event::Course::Role::Advisor)

        info.leaders.should eq 1
        info.leaders_total.should eq 1
      end

      it 'counts roles not people for cooks and speakers' do
        create(Event::Role::Leader, Event::Role::Cook, Event::Role::Speaker)

        info.leaders.should eq 2
        info.leaders_total.should eq 2
        info.cooks.should eq 1
        info.speakers.should eq 1
      end
    end

    context '#cantons' do
      it 'counts valid canton abbreviations on people' do
        create(course.participant_types.first).person.update_attribute(:canton, 'ag')
        create(course.participant_types.first).person.update_attribute(:canton, 'be')

        info.cantons.should eq 2
      end

      it 'counts both upper and lower case canton as valid' do
        create(course.participant_types.first).person.update_attribute(:canton, 'AG')

        info.cantons.should eq 1
      end

      it 'counts valid canton only once' do
        create(course.participant_types.first).person.update_attribute(:canton, 'ag')
        create(course.participant_types.first).person.update_attribute(:canton, 'ag')

        info.cantons.should eq 1
      end

      it 'warns about invalid canton values' do
        people(:flock_leader_bern).update_attributes(canton: 'Bern')

        info.warnings[:cantons].should be_true
      end
    end

    it 'sets participants and participants_total only once' do
      participant = create(course.participant_types.first)
      participant.update_attribute(:person, Fabricate(:person, birthday: 20.years.ago))

      info.participants.should eq 1
      info.participants_total.should eq 2
      info.cantons.should eq 0
    end

    context 'warnings on participants' do
      before { create(course.participant_types.first).person.update_attributes!(birthday: 35.years.ago, canton: 'BE') }

      it 'are not set if pariticpants have complete data' do
        people(:flock_leader_bern).update_attributes(birthday: Date.parse('1992-10-03'), canton: 'BE')

        info.warnings[:cantons].should be_false
        info.warnings[:participants].should be_false
      end

      it 'is set if participant are missing or have invalid data' do
        people(:flock_leader_bern).update_attributes(birthday: nil, canton: 'Bern')

        info.warnings[:cantons].should be_true
        info.warnings[:participants].should be_true
      end

    end
  end

end
