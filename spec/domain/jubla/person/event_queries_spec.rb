# encoding: utf-8

#  Copyright (c) 2012-2015, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Person::EventQueries do
  let(:person)          { participation1.participant }
  let(:event1)          { participation1.event }
  let(:event2)          { participation2.event }
  let(:participation1)  { role1.participation }
  let(:participation2)  { role2.participation }

  let(:queries) { Person::EventQueries.new(person) }

  subject { queries.coached_events }

  context :coach do
    let(:role1) { Fabricate(:event_role, type: Event::Camp::Role::Coach.sti_name )}
    let(:role2) { Fabricate(:event_role, type: Event::Camp::Role::Coach.sti_name )}

    before { role2.participation.update!(participant: person) }

    it 'can see event up to one month' do
      event1.dates.first.update!(finish_at: Time.zone.now + 20.days)
      event2.dates.first.update!(finish_at: Time.zone.now - 28.day)
      expect(subject.count).to eq(2)
      expect(queries.upcoming_events).to eq []
    end

    it 'can not see event more than one month ago' do
      event1.dates.first.update!(finish_at: Time.zone.now - 32.day)
      event2.dates.first.update!(finish_at: Time.zone.now - 2.years)
      expect(subject.count).to eq(0)
    end

    it 'ordered by date' do
      event1.dates.first.update_attribute(:start_at, Time.zone.now + 2.days)
      event2.dates.first.update_attribute(:start_at, Time.zone.now - 23.day)
      expect(subject.first).to eq(event2)
    end

  end

  context :advisor do
    let(:role1) { Fabricate(:event_role, type: Event::Course::Role::Advisor.sti_name )}

    it 'can see event 20 days ago' do
      event1.dates.first.update!(finish_at: Time.zone.now - 20.day)
      expect(subject.count).to eq(1)
      expect(queries.upcoming_events).to eq []
    end

    it 'can not see event 40 days ago' do
      event1.dates.first.update!(finish_at: Time.zone.now - 40.day)
      expect(subject.count).to eq(0)
    end
  end

  context 'other roles' do
    let(:role1) { Fabricate(:event_role, type: Event::Role::Speaker.sti_name )}

    it 'has empty coached list' do
      event1.dates.first.update!(finish_at: Time.zone.now)
      expect(subject.count).to eq(0)
    end

    it 'upcoming_events returns events that are active' do
      event1.dates.first.update!(start_at: 2.days.from_now, finish_at: 5.days.from_now)

      expect(queries.upcoming_events).to eq [event1]
    end

    it 'multiple roles appear twice' do
      Fabricate(:event_role, type: Event::Camp::Role::Coach.sti_name, participation: participation1)

      event1.dates.first.update!(start_at: 2.days.from_now, finish_at: 5.days.from_now)

      expect(queries.upcoming_events).to eq [event1]
      expect(subject).to eq [event1]
    end

  end
end
