# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Event::ParticipationsController do

  let(:group) { groups(:ch) }

  let(:course) do
    course = Fabricate(:jubla_course, groups: [group], priorization: true)
    course.questions << Fabricate(:event_question, event: course)
    course.questions << Fabricate(:event_question, event: course)
    course.dates << Fabricate(:event_date, event: course)
    course
  end

  let(:other_course) do
    other = Fabricate(:jubla_course, groups: [group], kind: course.kind)
    other.dates << Fabricate(:event_date, event: other, start_at: course.dates.first.start_at)
    other
  end

  let(:user) { people(:top_leader) }

  before { sign_in(user); other_course }


  context 'GET index' do
    before do
      @leader, @advisor, @participant = *create(Event::Role::Leader,
                                                Event::Course::Role::Advisor,
                                                course.participant_types.first)
    end

    it 'lists participant and leader group by default without advisor' do
      get :index, params: { group_id: group.id, event_id: course.id }
      expect(assigns(:participations)).to eq [@leader, @participant]
    end

    it 'lists only leader_group without advisor' do
      get :index, params: { group_id: group.id, event_id: course.id, filter: :teamers }
      expect(assigns(:participations)).to eq [@leader]
    end

    it 'lists only participant_group' do
      get :index, params: { group_id: group.id, event_id: course.id, filter: :participants }
      expect(assigns(:participations)).to eq [@participant]
    end

    it "shows the correct timestamps on the participation instances" do
      created_at = 2.days.ago.change(usec: 0)
      updated_at = 1.day.ago.change(usec: 0)
      Event::Participation.update_all(created_at:, updated_at:)

      get :index, params: {group_id: group.id, event_id: course.id}

      expect(assigns(:participations)).to eq [@leader, @participant]
      expect(assigns(:participations).map(&:created_at)).to eq [created_at, created_at]
      expect(assigns(:participations).map(&:updated_at)).to eq [updated_at, updated_at]
    end

    def create(*roles)
      roles.map do |role_class|
        role = Fabricate(:event_role, type: role_class.sti_name)
        Fabricate(:event_participation, event: course, roles: [role], state: 'assigned')
      end
    end
  end


end
