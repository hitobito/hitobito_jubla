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
    subject { Event::Course::BsvInfo::List.export([course, course]) }

    it 'exports semicolon separted list' do
      should eq ";;;01.03.2012;;;0;1;0;;8;1;1;0;0\n;;;01.03.2012;;;0;1;0;;8;1;1;0;0\n"
    end
  end

  it 'info straight form course or kind' do
    course.kind.update_attribute(:bsv_id, 'slk')
    course.update_attributes!(number: 'slk 123', training_days: 3,
                              application_contact: course.possible_contact_groups.first)

    info.kurs_id_fiver.should eq 'slk'
    info.number.should eq 'slk 123'
    info.training_days.should eq 3
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
      info.total_days.should eq 8
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

    it 'counts roles, not people for leader fields' do
      create(Event::Course::Role::Advisor,
             Event::Role::Cook,
             Event::Role::Speaker)

      info.leaders.should eq 1
      info.leaders_total.should eq 2

      info.cooks.should eq 1
      info.speakers.should eq 1
    end

    it 'sets cantons based on number of valid cantons of participants' do
      create(course.participant_type).person.update_attribute(:canton, 'ag')
      create(course.participant_type).person.update_attribute(:canton, 'Bern')
      people(:flock_leader_bern).update_attribute(:canton, 'BE')

      info.cantons.should eq 2
    end

    it 'sets participants and participants_total only once' do
      participant = create(course.participant_type)
      participant.update_attribute(:person, Fabricate(:person, birthday: 20.years.ago))

      info.participants.should eq 1
      info.participants_total.should eq 2
      info.cantons.should eq 0
    end

    context 'warnings on participants' do

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
