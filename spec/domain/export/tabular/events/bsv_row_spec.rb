# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Export::Tabular::Events::BsvRow do
  let(:course) { events(:top_course) }
  let(:participant) { people(:flock_leader_bern) }
  let(:info) { Export::Tabular::Events::BsvRow.new(course.reload) }

  def create_participation(*role_types)
    roles = role_types.map { |type| Fabricate(:event_role, type: type.name) }
    Fabricate(:event_participation, event: course, roles: roles, state: 'assigned')
  end

  def create_participant_with_person_attrs(attrs)
    participation = create_participation(course.participant_types.first)
    participation.person.update(attrs)
  end

  context 'info from dates' do
    it 'sets date to start_at of first date' do
      expect(info.first_event_date).to eq '01.03.2012'
    end

    it 'calculates total from summed date durations' do
      expect(info.total_day_count).to eq 9
    end

    it 'sets location from date with longest duration' do
      event_dates(:first_two).update_attribute(:location, 'somewhere')
      expect(info.location).to eq 'somewhere'
    end
  end

  context 'info from participations' do
    it 'handles null values' do
      course.participations.destroy_all

      %w(participant_count total_participant_count leader_count total_leader_count cook_count speaker_count).each do |attr|
        expect(info.send(attr.to_sym)).to eq 0
      end
    end

    context 'role counts' do
      it 'counts roles from fixtures' do
        expect(info.leader_count).to eq 1
        expect(info.total_leader_count).to eq 1
        expect(info.participant_count).to eq 0
        expect(info.total_participant_count).to eq 1

        expect(info.cook_count).to eq 0
        expect(info.speaker_count).to eq 0
      end

      it 'counts participation with multiple leader roles only once' do
        create_participation(Event::Role::Leader, Event::Role::Leader,
                             Event::Role::AssistantLeader)

        expect(info.total_leader_count).to eq 2
      end

      it 'counts roles not people for cook_count and speaker_count' do
        create_participation(Event::Role::Leader, Event::Role::Cook, Event::Role::Speaker)

        expect(info.total_leader_count).to eq 2
        expect(info.cook_count).to eq 1
        expect(info.speaker_count).to eq 1
      end

      it 'does not count Advisor role' do
        create_participation(Event::Course::Role::Advisor)

        expect(info.leader_count).to eq 1
        expect(info.total_leader_count).to eq 1
      end
    end

    context '#participant_count' do
      it 'does not count participant_count born 16 years before course year' do
        participant.update_attribute(:birthday, '01.01.1996')
        expect(info.participant_count).to eq 0
      end

      it 'counts participant born 17 years before course year' do
        participant.update_attribute(:birthday, '31.12.1995')
        expect(info.participant_count).to eq 1
      end

      it 'counts participant born 30 years before course year' do
        participant.update_attribute(:birthday, '01.01.1982')
        expect(info.participant_count).to eq 1
      end

      it 'does not count participant_count born 31 years before course year' do
        participant.update_attribute(:birthday, '31.12.1981')
        expect(info.participant_count).to eq 0
      end
    end

    context 'cantons' do
      let(:birthday) { '01.01.1982' }

      it 'counts valid canton abbreviations of particpants aged 17 to 30' do
        create_participant_with_person_attrs(canton: 'ag', birthday: birthday)
        create_participant_with_person_attrs(canton: 'be', birthday: birthday)
        expect(info.canton_count).to eq 2
      end

      it 'counts valid abbreviations only once' do
        2.times { create_participant_with_person_attrs(canton: 'ag', birthday: birthday) }
        expect(info.canton_count).to eq 1
      end

      it 'ignores case when counting' do
        create_participant_with_person_attrs(canton: 'AG', birthday: birthday)
        expect(info.canton_count).to eq 1
      end

      it 'ignores cantons on people outside of aged 17 to 30 group' do
        create_participant_with_person_attrs(canton: 'ag', birthday: '31.12.1981')
        expect(info.canton_count).to eq 0
      end
    end
  end

end
