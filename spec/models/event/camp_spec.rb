# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'
require_relative '../../support/fabrication.rb'

describe Event::Camp do

  describe '.role_types' do
    subject { Event::Camp.role_types }

    it { is_expected.to include(Event::Role::Leader) }
    it { is_expected.to include(Event::Role::AssistantLeader) }
    it { is_expected.to include(Event::Role::Cook) }
    it { is_expected.to include(Event::Role::Treasurer) }
    it { is_expected.to include(Event::Role::Speaker) }
    it { is_expected.to include(Event::Role::Participant) }
    it { is_expected.to include(Event::Camp::Role::Coach) }
  end

  context '.kind_class' do
    subject { Event::Camp.kind_class }

    it 'is loaded correctly' do
      is_expected.to eq(Event::Camp::Kind)
      subject.name == 'Event::Camp::Kind'
    end

  end

  context '#coach' do
    let(:person)  { Fabricate(:person) }
    let(:person1) { Fabricate(:person) }

    let(:event)   { Fabricate(:camp, coach_id: person.id).reload }

    subject { event }

    its(:coach) { should == person }
    its(:coach_id) { should == person.id }

    it "shouldn't change the coach if the same is already set" do
      subject.coach_id = person.id
      expect { subject.save! }.not_to change { Event::Role.count }
      expect(subject.coach).to eq person
    end

    it 'should update the coach if another person is assigned' do
      event.coach_id = person1.id
      expect(event.save).to be_truthy
      expect(event.coach).to eq person1
    end

    it "shouldn't try to add coach if id is empty" do
      event = Fabricate(:camp, coach_id: '')
      expect(event.coach).to be nil
    end

    it 'removes existing coach if id is set blank' do
      subject.coach_id = person.id
      subject.save!

      subject.coach_id = ''
      expect { subject.save! }.to change { Event::Role.count }.by(-1)
    end

    it 'removes existing and creates new coach on reassignment' do
      subject.coach_id = person.id
      subject.save!

      new_coach = Fabricate(:person)
      subject.coach_id = new_coach.id
      expect { subject.save! }.not_to change { Event::Role.count }
      expect(Event.find(subject.id).coach_id).to eq(new_coach.id)
      expect(subject.participations.where(person_id: person.id)).not_to be_exists
    end

  end

end
