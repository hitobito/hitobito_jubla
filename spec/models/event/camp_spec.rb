# encoding: utf-8
# == Schema Information
#
# Table name: events
#
#  id                          :integer          not null, primary key
#  type                        :string(255)
#  name                        :string(255)      not null
#  number                      :string(255)
#  motto                       :string(255)
#  cost                        :string(255)
#  maximum_participants        :integer
#  contact_id                  :integer
#  description                 :text(65535)
#  location                    :text(65535)
#  application_opening_at      :date
#  application_closing_at      :date
#  application_conditions      :text(65535)
#  kind_id                     :integer
#  state                       :string(60)
#  priorization                :boolean          default(FALSE), not null
#  requires_approval           :boolean          default(FALSE), not null
#  created_at                  :datetime
#  updated_at                  :datetime
#  participant_count           :integer          default(0)
#  application_contact_id      :integer
#  external_applications       :boolean          default(FALSE)
#  applicant_count             :integer          default(0)
#  teamer_count                :integer          default(0)
#  signature                   :boolean
#  signature_confirmation      :boolean
#  signature_confirmation_text :string(255)
#  creator_id                  :integer
#  updater_id                  :integer
#  applications_cancelable     :boolean          default(FALSE), not null
#  required_contact_attrs      :text(65535)
#  hidden_contact_attrs        :text(65535)
#  display_booking_info        :boolean          default(TRUE), not null
#  training_days               :decimal(12, 1)
#  tentative_applications      :boolean          default(FALSE), not null
#  condition_id                :integer
#  remarks                     :text(65535)
#

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
      expect(subject.participations.where(participant_id: person.id, participant_type: Person.sti_name)).not_to be_exists
    end

  end

end
