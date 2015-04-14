# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe EventsController do

  context 'event_course' do
    let(:group) { groups(:ch) }
    let(:date)  { { label: 'foo', start_at_date: Date.today, finish_at_date: Date.today } }
    let(:event) { assigns(:event) }

    let(:event_attrs) { { group_ids: [group.id], name: 'foo',
                          kind_id: Event::Kind.where(short_name: 'SLK').first.id,
                          dates_attributes: [date], type: 'Event::Course' } }


    before { sign_in(people(:top_leader)) }

    it 'creates new event course with dates, advisor' do
      post :create, event: event_attrs.merge(contact_id: Person.first, advisor_id: Person.last), group_id: group.id
      expect(event.dates).to have(1).item
      expect(event.dates.first).to be_persisted
      expect(event.contact).to eq Person.first
      expect(event.advisor).to eq Person.last
    end

    it 'creates new event course without contact, advisor' do
      post :create, event: event_attrs.merge(contact_id: '', advisor_id: ''), group_id: group.id

      expect(event.contact).not_to be_present
      expect(event.advisor).not_to be_present
      expect(event).to be_persisted
    end

    it 'should set application contact if only one is available' do
      post :create, event: event_attrs, group_id: group.id

      expect(event.application_contact).to eq event.possible_contact_groups.first
    end

    it 'should set training days' do
      post :create, event: event_attrs.merge(training_days: 5), group_id: group.id

      expect(event.training_days).to eq 5
    end

    after do
      expect(event).to be_persisted
      is_expected.to redirect_to(group_event_path(group, event))
    end
  end

  context 'event_camp' do

    before { sign_in(people(:flock_leader)) }

    context 'create with coach' do

      let(:group) { groups(:innerroden) }
      let(:date)  { { label: 'foo', start_at_date: Date.today, finish_at_date: Date.today } }
      let(:contact) { Person.first }
      let(:coach) { Person.last }

      it 'creates new event camp with dates,coach' do
        post :create, event: {  group_ids: [group.id],
                                name: 'foo',
                                kind_id: Event::Kind.where(short_name: 'SLK').first.id,
                                dates_attributes: [date],
                                contact_id: contact.id,
                                coach_id: coach.id,
                                type: 'Event::Camp' },
                      group_id: group.id


        event = assigns(:event)

        is_expected.to redirect_to(group_event_path(group, event))

        expect(event).to be_persisted
        expect(event.dates).to have(1).item
        expect(event.dates.first).to be_persisted
        expect(event.contact).to eq contact
        expect(event.coach).to eq coach
      end
    end

    context '#new with default coach' do

      let(:flock) { groups(:innerroden) }
      let(:date)  { { label: 'foo', start_at_date: Date.today, finish_at_date: Date.today } }
      let(:coach) { people(:top_leader) }

      it '#new event camp it should set default coach' do
        # assign flock coach
        Fabricate(:role, group: flock, type: 'Group::Flock::Coach', person: coach)

        get :new, event: {  group_ids: [flock.id],
                            type: 'Event::Camp' },
                  group_id: flock.id

        event = assigns(:event)
        expect(event.coach).to eq coach
      end

      it '#new event camp it should NOT set default coach' do
        # no flock coach assigned
        get :new, event: {  group_ids: [flock.id],
                            type: 'Event::Camp' },
                  group_id: flock.id

        event = assigns(:event)
        expect(event.coach).to be nil
      end
    end
  end


  context '#index filters based on type' do
    require_relative '../support/fabrication.rb'
    before { sign_in(people(:top_leader)) }

    context 'Jubla Schweiz' do
      let(:group) { groups(:ch) }
      let!(:event) { Fabricate(:event, groups: [group]) }
      let!(:course) { Fabricate(:jubla_course, groups: [group]) }


      it 'lists events' do
        get :index, group_id: group.id, year: 2012
        expect(assigns(:events)).to eq [event, events(:top_event)]
      end

      it 'lists courses' do
        get :index, group_id: group.id, year: 2012, type: Event::Course.sti_name
        expect(assigns(:events)).to eq [course]
      end
    end

    context 'Schar Thun' do
      let(:group) { groups(:thun) }
      let!(:event) { Fabricate(:event, groups: [group]) }
      let!(:camp) { Fabricate(:camp, groups: [group]) }

      it 'lists event' do
        get :index, group_id: group.id, year: 2012
        expect(assigns(:events)).to eq [event]
      end


      it 'lists camp' do
        get :index, group_id: group.id, year: 2012, type: Event::Camp.sti_name
        expect(assigns(:events)).to eq [camp]
      end

    end
  end

end
