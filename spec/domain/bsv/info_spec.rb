# encoding: utf-8

#  Copyright (c) 2012-2015, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Bsv::Info do
  let(:course) { events(:top_course) }
  let(:course_year) { course.dates.first.start_at.year }
  before { course.participations.destroy_all }

  it '#location is read from course' do
    course.update!(location: 'dummy')
    expect(info.location).to eq 'dummy'
  end

  it '#location is read from date when set' do
    course.update!(location: 'dummy')
    course.dates.first.update!(location: 'elsewhere')
    expect(info.location).to eq 'elsewhere'
  end

  it '#total_day_count counts total number of days' do
    expect(info.total_day_count).to eq 9
  end

  it '#cook_count counts cooks' do
    create_participation(Event::Role::Cook)
    expect(info.cook_count).to eq 1
  end

  it '#speaker_count counts cooks' do
    create_participation(Event::Role::Speaker)
    expect(info.speaker_count).to eq 1
  end

  it '#total_leader_count counts all leader roles without advisor' do
    create_participation(Event::Role::Leader)
    create_participation(Event::Role::AssistantLeader)
    expect(info.total_leader_count).to eq 2

    create_participation(Event::Role::Speaker)
    create_participation(Event::Role::Cook)
    expect(info.total_leader_count).to eq 4

    create_participation(Event::Course::Role::Advisor)
    expect(info.total_leader_count).to eq 4
  end

  it '#participant_count includes participant of valid age without ch residence' do
    create_participant(birthday: Date.new(course_year - 18, 1, 1))
    expect(info.participant_count).to eq 1
  end

  it '#total_participant_count counts all active participants regardless of age or residence' do
    create_participant
    expect(info.total_participant_count).to eq 1
  end

  it '#warnings.participant_count is set if any participant has missing birthday' do
    create_participant(birthday: Date.today)
    expect(info.warnings[:participant_count]).to eq(false)

    create_participant
    expect(info.warnings[:participant_count]).to eq(true)
    expect(info.error(:participant_count)).to eq 'Nicht alle Teilnehmer haben den Geburtstag gestetzt.'
  end

  it '#warnings.canton_count is set if any participant has missing canton' do
    create_participant(zip_code: 3000)
    expect(info.warnings[:canton_count]).to eq(false)

    create_participant
    expect(info.warnings[:canton_count]).to eq(true)
    expect(info.error(:canton_count)).to eq 'Nicht alle Teilnehmer haben einen gültigen Kanton gesetzt.'
  end

  it '#warnings.canton_count is set if any participant has invalid 2 letter canton abbrevation' do
    create_participant(canton: 'Bern')
    expect(info.warnings[:canton_count]).to eq(true)
    expect(info.error(:canton_count)).to eq 'Nicht alle Teilnehmer haben einen gültigen Kanton gesetzt.'
  end

  private

  def info
    Bsv::Info.new(course.reload)
  end

  def create_participant(person_attrs = {})
    create_participation(Event::Course::Role::Participant, Fabricate(:person, person_attrs))
  end

  def create_participation(role, person = nil)
    person ||= Fabricate(:person)
    participation = Fabricate(:event_participation, event: course, person: person)
    Fabricate(role.to_s.to_sym, participation: participation)
  end
end
