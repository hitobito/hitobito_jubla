# encoding: utf-8

#  Copyright (c) 2012-2015, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Event::Camp do

  let(:person) { participation.person }
  let(:event) { participation.event }
  let(:participation) { role.participation }

  context :coach do
    let(:role) { Fabricate(:event_role, type: Event::Camp::Role::Coach.sti_name )}

    it 'can see event 20 days ago' do
      event.dates.first.update(finish_at: Time.now - 20.day)
      p = PersonDecorator.new(person)
      expect(p.coached_events.count).to eq(1)
    end

    it 'can not see event 40 days ago' do
      event.dates.first.update(finish_at: Time.now - 40.day)
      p = PersonDecorator.new(person)
      expect(p.coached_events.count).to eq(0)
    end
  end

  context :assistant_leader do
    let(:role) { Fabricate(:event_role, type: Event::Course::Role::Advisor.sti_name )}

    it 'can see event 20 days ago' do
      event.dates.first.update(finish_at: Time.now - 20.day)
      p = PersonDecorator.new(person)
      expect(p.coached_events.count).to eq(1)
    end

    it 'can not see event 40 days ago' do
      event.dates.first.update(finish_at: Time.now - 40.day)
      p = PersonDecorator.new(person)
      expect(p.coached_events.count).to eq(0)
    end
  end
end
