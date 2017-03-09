# encoding: utf-8

#  Copyright (c) 2012-2015, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Person::EventQueries do
  let(:person)          { participation1.person }
  let(:event1)          { participation1.event }
  let(:event2)          { participation2.event }
  let(:participation1)  { role1.participation }
  let(:participation2)  { role2.participation }
 
  subject { PersonDecorator.new(person).coached_events }

  context :coach do
    let(:role1) { Fabricate(:event_role, type: Event::Camp::Role::Coach.sti_name )}
    let(:role2) { Fabricate(:event_role, type: Event::Camp::Role::Coach.sti_name )}

    before { role2.person = person }

    it 'can see event 20 days ago' do
      event1.dates.first.update(finish_at: Time.now - 20.day)
      event2.dates.first.update(finish_at: Time.now - 23.day)
      expect(subject.count).to eq(2)
    end

    it 'can not see event 40 days ago' do
      event1.dates.first.update(finish_at: Time.now - 40.day)
      event2.dates.first.update(finish_at: Time.now - 43.day)
      expect(subject.count).to eq(0)
    end

    it 'ordered by date' do
      event1.dates.first.update_attribute(:start_at, Time.now - 20.day)
      event2.dates.first.update_attribute(:start_at, Time.now - 23.day)
      expect(subject.first).to eq(event2)
    end

    it 'ordered by date' do
      event1.dates.first.update_attribute(:start_at, Time.now - 23.day)
      event2.dates.first.update_attribute(:start_at, Time.now - 20.day)
      expect(subject.first).to eq(event1)
    end

  end

  context :assistant_leader do
    let(:role1) { Fabricate(:event_role, type: Event::Course::Role::Advisor.sti_name )}

    it 'can see event 20 days ago' do
      event1.dates.first.update(finish_at: Time.now - 20.day)
      expect(subject.count).to eq(1)
    end

    it 'can not see event 40 days ago' do
      event1.dates.first.update(finish_at: Time.now - 40.day)
      expect(subject.count).to eq(0)
    end
  end

  context 'other roles' do
    let(:role1) { Fabricate(:event_role, type: Event::Role::Speaker.sti_name )}

    it 'doesn\'t see event list' do
      event1.dates.first.update(finish_at: Time.now - 20.day)
      expect(subject.count).to eq(0)
    end
  
  end
end
