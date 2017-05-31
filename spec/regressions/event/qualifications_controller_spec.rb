# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Event::QualificationsController, type: :controller do

  render_views

  let(:event) do
    event = Fabricate(:jubla_course, kind: Event::Kind.where(short_name: 'SLK').first)
    event.dates.create!(start_at: 10.days.ago, finish_at: 5.days.ago)
    event
  end

  let(:group) { event.groups.first }

  let(:participant_1) do
    participation = Fabricate(:event_participation, event: event)
    Fabricate(Event::Course::Role::Participant.name.to_sym, participation: participation)
    participation
  end

  let(:participant_2) do
    participation = Fabricate(:event_participation, event: event)
    Fabricate(Event::Course::Role::Participant.name.to_sym, participation: participation)
    participation
  end

  let(:dom) { Capybara::Node::Simple.new(response.body) }

  before { sign_in(people(:top_leader)) }

  before do
    participant_1
    participant_2
  end

  describe 'GET index' do

    context 'in open state' do
      before { get :index, group_id: group.id, event_id: event.id }

      subject { assigns(:participants) }

      it { is_expected.to have(2).items }

      it 'should have enabled checkboxes' do
        expect(dom.find("#event_participation_#{participant_1.id} td:first")).to have_selector('input[type=checkbox]')
        expect(dom.find("#event_participation_#{participant_1.id} td:first")).to have_no_selector('input[type=checkbox][disabled]')
      end

      it 'should not have message' do
        expect(dom).not_to have_content('können die Qualifikationen nicht mehr bearbeitet werden')
      end
    end

    context 'in closed state' do
      before { event.update_column(:state, 'closed') }
      before { get :index, group_id: group.id, event_id: event.id }

      subject { assigns(:participants) }

      it { is_expected.to have(2).items }

      it 'should have message' do
        expect(dom).to have_content('können die Qualifikationen nicht mehr bearbeitet werden')
      end

      it 'should have disabled checkboxes' do
        expect(dom.find("#event_participation_#{participant_1.id} td:first")).to have_selector('input[type=checkbox][disabled]')
      end

    end
  end

  describe 'PUT update' do
    context 'adding' do
      context 'in open state' do
        before { put :update, group_id: group.id, event_id: event.id, participation_ids: [participant_1.id.to_s] }

        subject { obtained_qualifications }

        it { is_expected.to have(1).item }
      end

      context 'in closed state' do
        before { event.update_column(:state, 'closed') }
        before { put :update, group_id: group.id, event_id: event.id, participation_ids: [participant_1.id.to_s] }

        subject { obtained_qualifications }

        it { is_expected.to have(0).items }
      end
    end

    context 'removing' do
      before do
        id = event.kind.event_kind_qualification_kinds.first.qualification_kind_id
        participant_1.person.qualifications.create!(qualification_kind_id: id,
                                                    start_at: event.qualification_date)
      end

      context 'in open state' do
        before { put :update, group_id: group.id, event_id: event.id }

        subject { obtained_qualifications }

        it { is_expected.to have(0).item }
      end

      context 'in closed state' do
        before { event.update_column(:state, 'closed') }
        before { put :update, group_id: group.id, event_id: event.id, participation_ids: [] }

        subject { obtained_qualifications }

        it { is_expected.to have(1).items }
      end

    end
  end

  def obtained_qualifications
    q = Event::Qualifier.for(participant_1)
    q.send(:obtained, q.send(:qualification_kinds))
  end

end
