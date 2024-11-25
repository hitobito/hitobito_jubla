#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Event::ParticipationsController, type: :controller do
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

  before { sign_in(people(:top_leader)) }

  before do
    participant_1
    participant_2
  end

  describe 'GET index' do
    it "should be able to sort by originating_state asc" do
      get :index, params: { group_id: group.id, event_id: event.id, sort: :originating_state, sort_dir: :asc }
      expect(response).to have_http_status(:ok)
      expect(assigns(:participations)).to match_array([participant_1, participant_2])
    end

    it "should be able to sort by originating_state desc" do
      get :index, params: { group_id: group.id, event_id: event.id, sort: :originating_state, sort_dir: :desc }
      expect(response).to have_http_status(:ok)
      expect(assigns(:participations)).to match_array([participant_2, participant_1])
    end

    it "should be able to sort by originating_flock asc" do
      get :index, params: { group_id: group.id, event_id: event.id, sort: :originating_flock, sort_dir: :asc }
      expect(response).to have_http_status(:ok)
      expect(assigns(:participations)).to match_array([participant_1, participant_2])
    end

    it "should be able to sort by originating_flock desc" do
      get :index, params: { group_id: group.id, event_id: event.id, sort: :originating_flock, sort_dir: :desc }
      expect(response).to have_http_status(:ok)
      expect(assigns(:participations)).to match_array([participant_2, participant_1])
    end
  end
end