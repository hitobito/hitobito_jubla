# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe EventAbility do

  let(:user) { role.person }
  let(:group) { role.group }
  let(:event) { Fabricate(:event, groups: [group]) }

  let(:participant) { Fabricate(Group::Flock::Guide.name.to_sym, group: groups(:bern)).person }
  let(:participation) { Fabricate(:event_participation, person: participant, event: event, application: Fabricate(:jubla_event_application)) }


  subject { Ability.new(user.reload) }

  context :layer_and_below_full do
    let(:role) { Fabricate(Group::StateAgency::Leader.name.to_sym, group: groups(:be_agency)) }

    context Event do
      it 'may create event in his group' do
        is_expected.to be_able_to(:create, group.events.new.tap { |e| e.groups << group })
      end

      it 'may create event in his layer' do
        is_expected.to be_able_to(:create, groups(:be).events.new.tap { |e| e.groups << group })
      end

      it 'may update event in his layer' do
        is_expected.to be_able_to(:update, event)
      end

      it 'may index people for event in his layer' do
        is_expected.to be_able_to(:index_participations, event)
      end

      it 'may update event in lower layer' do
        other = Fabricate(:event, groups: [groups(:bern)])
        is_expected.to be_able_to(:update, other)
      end

      it 'may not update event in other layer' do
        other = Fabricate(:event, groups: [groups(:no)])
        is_expected.not_to be_able_to(:update, other)
      end

      it 'may index people for event in lower layer' do
        other = Fabricate(:event, groups: [groups(:bern)])
        is_expected.to be_able_to(:index_participations, other)
      end

      it 'may not index people for event in other layer' do
        other = Fabricate(:event, groups: [groups(:no)])
        is_expected.not_to be_able_to(:index_participations, other)
      end
    end


    context Event::Participation do
      before { Fabricate(Event::Role::Participant.name.to_sym, participation: participation) }

      it 'may show participation' do
        is_expected.to be_able_to(:show, participation)
      end

      it 'may create participation' do
        is_expected.to be_able_to(:create, participation)
      end

      it 'may update participation' do
        is_expected.to be_able_to(:update, participation)
      end

      it 'may destroy participation' do
        is_expected.to be_able_to(:destroy, participation)
      end

      it 'may show participation in event from lower layer' do
        other = Fabricate(:event_participation, event: Fabricate(:event, groups: [groups(:bern)]))
        is_expected.to be_able_to(:show, other)
      end

      it 'may not show participation in event from other layer' do
        other = Fabricate(:event_participation, event: Fabricate(:event, groups: [groups(:no)]))
        is_expected.not_to be_able_to(:show, other)
      end

      it 'may still create when application is not possible' do
        allow(event).to receive_messages(application_possible?: false)
        is_expected.to be_able_to(:create, participation)
      end
    end

  end

  context :group_full do
    let(:role) { Fabricate(Group::StateBoard::GroupAdmin.name.to_sym, group: groups(:be_board)) }

    context Event do
      it 'may create event in his group' do
        is_expected.to be_able_to(:create, group.events.new.tap { |e| e.groups << group })
      end

      it 'may update event in his group' do
        is_expected.to be_able_to(:update, event)
      end

      it 'may destroy event in his group' do
        is_expected.to be_able_to(:destroy, event)
      end

      it 'may index people for event in his layer' do
        is_expected.to be_able_to(:index_participations, event)
      end

      it 'may not update event in other group' do
        other = Fabricate(:event, groups: [groups(:be_agency)])
        is_expected.not_to be_able_to(:update, other)
      end

      it 'may not index people for event in other group' do
        other = Fabricate(:event, groups: [groups(:be_agency)])
        is_expected.not_to be_able_to(:index_participations, other)
      end
    end

    context Event::Participation do
      before { Fabricate(Event::Role::Participant.name.to_sym, participation: participation) }

      it 'may show participation' do
        is_expected.to be_able_to(:show, participation)
      end

      it 'may create participation' do
        is_expected.to be_able_to(:create, participation)
      end

      it 'may update participation' do
        is_expected.to be_able_to(:update, participation)
      end

      it 'may destroy participation' do
        is_expected.to be_able_to(:destroy, participation)
      end

      it 'may not show participation in event from other group' do
        other = Fabricate(:event_participation, event: Fabricate(:event, groups: [groups(:be_agency)]))
        is_expected.not_to be_able_to(:show, other)
      end
    end

  end

  context :event_full do
    let(:group) { groups(:be) }
    let(:role) { Fabricate(Group::StateBoard::Member.name.to_sym, group: groups(:be_board)) }
    let(:participation) { Fabricate(:event_participation, event: event, person: user) }

    before { Fabricate(Event::Role::Leader.name.to_sym, participation: participation) }

    context Event do
      it 'may not create events' do
        is_expected.not_to be_able_to(:create, group.events.new.tap { |e| e.groups << group })
      end

      it 'may update his event' do
        is_expected.to be_able_to(:update, event)
      end

      it 'may not destroy his event' do
        is_expected.not_to be_able_to(:destroy, event)
      end

      it 'may index people his event' do
        is_expected.to be_able_to(:index_participations, event)
      end

      it 'may not update other event' do
        other = Fabricate(:event, groups: [group])
        is_expected.not_to be_able_to(:update, other)
      end

      it 'may not index people for other event' do
        other = Fabricate(:event, groups: [group])
        is_expected.not_to be_able_to(:index_participations, other)
      end

    end

    context Event::Participation do
      let(:other) { Fabricate(:event_participation, event: event) }
      before { Fabricate(Event::Role::Participant.name.to_sym, participation: other) }

      it 'may show participation' do
        is_expected.to be_able_to(:show, other)
      end

      it 'may not create participation' do
        is_expected.not_to be_able_to(:create, other)
      end

      it 'may update participation' do
        is_expected.to be_able_to(:update, other)
      end

      it 'may not destroy participation' do
        is_expected.not_to be_able_to(:destroy, other)
      end

      it 'may not show participation in other event' do
        other = Fabricate(:event_participation, event: Fabricate(:event, groups: [group]))
        is_expected.not_to be_able_to(:show, other)
      end

      it 'may not update participation in other event' do
        other = Fabricate(:event_participation, event: Fabricate(:event, groups: [group]))
        is_expected.not_to be_able_to(:update, other)
      end
    end

  end

  context :event_contact_data do
    let(:role) { Fabricate(Group::StateBoard::Member.name.to_sym, group: groups(:be_board)) }
    let(:event) { Fabricate(:event, groups: [groups(:be)]) }
    let(:participation) { Fabricate(:event_participation, event: event, person: user) }

    before { Fabricate(Event::Role::Cook.name.to_sym, participation: participation) }

    context Event do
      it 'may show his event' do
        is_expected.to be_able_to(:show, event)
      end

      it 'may not create events' do
        is_expected.not_to be_able_to(:create, groups(:be).events.new.tap { |e| e.groups << group })
      end

      it 'may not update his event' do
        is_expected.not_to be_able_to(:update, event)
      end

      it 'may not destroy his event' do
        is_expected.not_to be_able_to(:destroy, event)
      end

      it 'may index people for his event' do
        is_expected.to be_able_to(:index_participations, event)
      end

      it 'may show other event' do
        other = Fabricate(:event, groups: [groups(:be)])
        is_expected.to be_able_to(:show, other)
      end

      it 'may not update other event' do
        other = Fabricate(:event, groups: [groups(:be)])
        is_expected.not_to be_able_to(:update, other)
      end

      it 'may not index people for other event' do
        other = Fabricate(:event, groups: [groups(:be)])
        is_expected.not_to be_able_to(:index_participations, other)
      end

    end

    context Event::Participation do
      it 'may show his participation' do
        is_expected.to be_able_to(:show, participation)
      end

      it 'may show other participation' do
        other = Fabricate(:event_participation, event: event)
        Fabricate(Event::Role::Participant.name.to_sym, participation: other)
        is_expected.to be_able_to(:show, other)
      end

      it 'may not show details of other participation' do
        other = Fabricate(:event_participation, event: event)
        Fabricate(Event::Role::Participant.name.to_sym, participation: other)
        is_expected.not_to be_able_to(:show_details, other)
      end

      it 'may not show participation in other event' do
        other = Fabricate(:event_participation, event: Fabricate(:event, groups: [group]))
        Fabricate(Event::Role::Participant.name.to_sym, participation: other)
        is_expected.not_to be_able_to(:show, other)
      end

      it 'may not update his participation' do
        is_expected.not_to be_able_to(:update, participation)
      end

      it 'may not update other participation' do
        other = Fabricate(:event_participation, event: event)
        Fabricate(Event::Role::Participant.name.to_sym, participation: other)
        is_expected.not_to be_able_to(:update, other)
      end
    end

  end

  context :in_same_hierarchy do
    let(:role) { Fabricate(Group::Flock::Guide.name.to_sym, group: groups(:bern)) }
    let(:participation) { Fabricate(:event_participation, person: user, event: event) }

    context Event::Participation do
      it 'may create his participation' do
        p           = event.participations.new
        p.person_id = user.id
        is_expected.to be_able_to(:create, p)
      end

      it 'may show his participation' do
        is_expected.to be_able_to(:show, participation)
      end

      it 'may not update his participation' do
        is_expected.not_to be_able_to(:update, participation)
      end

    end

  end

  context :in_other_hierarchy do
    let(:role) { Fabricate(Group::Flock::Guide.name.to_sym, group: groups(:innerroden)) }
    let(:event) { Fabricate(:jubla_course, groups: [groups(:be)]) }
    let(:participation) { Fabricate(:event_participation, person: user, event: event) }

    context Event::Participation do
      it 'may create his participation' do
        allow(participation.event).to receive_messages(application_possible?: true)
        is_expected.to be_able_to(:create, participation)
      end

      it 'may not create his participation if application is not possible' do
        allow(participation.event).to receive_messages(application_possible?: false)
        is_expected.not_to be_able_to(:create, participation)
      end

      it 'may show his participation' do
        is_expected.to be_able_to(:show, participation)
      end

      it 'may not update his participation' do
        is_expected.not_to be_able_to(:update, participation)
      end
    end

  end

  context :admin do
    let(:role) { Fabricate(Group::FederalBoard::Member.name.to_sym, group: groups(:federal_board)) }

    it 'may manage event kinds' do
      is_expected.to be_able_to(:manage, Event::Kind)
    end
  end

  context :flock_leader do
    let(:event) { Fabricate(:jubla_course, groups: [groups(:be)]) }
    let(:role) { Fabricate(Group::Flock::Leader.name.to_sym, group: groups(:bern)) }

    context 'for his guides' do
      it 'may show participations' do
        is_expected.to be_able_to(:show, participation)
      end

      it 'may show application' do
        is_expected.to be_able_to(:show_priorities, participation.application)
      end

      it 'may approve participations' do
        is_expected.to be_able_to(:approve, participation.application)
      end
    end

    context 'for other participants' do
      let(:participant) { Fabricate(Group::Flock::Guide.name.to_sym, group: groups(:muri)).person }

      it 'may not show participations' do
        is_expected.not_to be_able_to(:show, participation)
      end

      it 'may not show application' do
        is_expected.not_to be_able_to(:show_priorities, participation.application)
      end

      it 'may not approve participations' do
        is_expected.not_to be_able_to(:approve, participation.application)
      end
    end
  end

  context :application_market do
    let(:ast_event) { Fabricate(:event, groups: [groups(:be)]) }
    let(:bulei_event) { Fabricate(:event, groups: [groups(:ch)]) }

    context :bulei do
      let(:role) { Fabricate(Group::FederalBoard::Member.name.to_sym, group: groups(:federal_board)) }
      it 'allowed for bulei event' do
        is_expected.to be_able_to(:application_market, bulei_event)
      end
      it 'denied for ast event' do
        is_expected.not_to be_able_to(:application_market, ast_event)
      end
    end

    context :ast do
      let(:role) { Fabricate(Group::StateAgency::Leader.name.to_sym, group: groups(:be_agency)) }
      it 'denied for bulei event' do
        is_expected.not_to be_able_to(:application_market, bulei_event)
      end
      it 'should for ast event' do
        is_expected.to be_able_to(:application_market, ast_event)
      end
    end
  end

  context :qualify do
    let(:ast_event) { Fabricate(:event, groups: [groups(:be)]) }
    let(:bulei_event) { Fabricate(:event, groups: [groups(:ch)]) }

    before do
      [ast_event, bulei_event].each do |event|
        participation = Fabricate(:event_participation, event: event, person: user)
        Fabricate(:event_role, participation: participation, type: 'Event::Role::Leader')
      end
    end

    context :bulei do
      let(:role) { Fabricate(Group::FederalBoard::Member.name.to_sym, group: groups(:federal_board)) }
      it 'allowed for bulei event' do
        is_expected.to be_able_to(:qualify, bulei_event)
      end
      it 'allowed for ast event' do
        is_expected.to be_able_to(:qualify, ast_event)
      end
    end

    context :ast do
      let(:role) { Fabricate(Group::StateAgency::Leader.name.to_sym, group: groups(:be_agency)) }
      it 'allowed for bulei event' do
        is_expected.to be_able_to(:qualify, bulei_event)
      end
      it 'allowed for ast event' do
        is_expected.to be_able_to(:qualify, ast_event)
      end
    end
  end

  context :closed_courses do
    let(:course) { Fabricate(:jubla_course, groups: [groups(:be)], state: 'closed') }

    let(:event) { Fabricate(:event, groups: [groups(:be)], state: 'closed') }
    let(:participation) { Fabricate(:event_participation, event: course) }

    context :bulei do
      let(:role) { Fabricate(Group::FederalBoard::Member.name.to_sym, group: groups(:federal_board)) }

      it 'can use application_market, destroy, qualify or update' do
        course = Fabricate(:jubla_course, groups: [groups(:ch)], state: 'closed')
        [:application_market, :destroy, :qualify, :update].each do |action|
          is_expected.to be_able_to(action, course)
        end
      end

      it 'can assign qualifications' do
        create_qualifying_participation(user, course)
        is_expected.to be_able_to(:qualify, course)
      end

      it 'can create, update, destroy participations' do
        course        = Fabricate(:jubla_course, groups: [groups(:ch)], state: 'closed')
        participation = Fabricate(:event_participation, event: course)
        [:create, :update, :destroy].each { |action| is_expected.to be_able_to(action, participation) }
      end

      it 'can manage event role' do
        role = create_qualifying_participation(user, course)
        is_expected.to be_able_to(:manage, role)
      end
    end

    context :ast do
      let(:role) { Fabricate(Group::StateAgency::Leader.name.to_sym, group: groups(:be_agency)) }

      it 'cannot use application_market, destroy, qualify or update' do
        [:application_market, :destroy, :qualify, :update].each do |action|
          is_expected.not_to be_able_to(action, course)
        end
      end

      it 'cannot assign qualifications' do
        create_qualifying_participation(user, course)
        is_expected.not_to be_able_to(:qualify, course)
      end

      it 'cannot create, update, destroy participations' do
        [:create, :update, :destroy].each { |action| is_expected.not_to be_able_to(action, participation) }
      end

      it 'cannot manage event role' do
        role = create_qualifying_participation(user, course)
        is_expected.not_to be_able_to(:manage, role)
      end
    end

    def create_qualifying_participation(user, event)
      participation = Fabricate(:event_participation, event: event, person: user)
      Fabricate(:event_role, participation: participation, type: 'Event::Role::Leader')
    end
  end

  context 'destroyed group' do
    let(:group) { groups(:ausserroden) }
    let(:role) { Fabricate(Group::Flock::Leader.name.to_sym, group: group) }
    before { group.destroy }

    it 'cannot create new event' do
      is_expected.not_to be_able_to(:create, group.events.new.tap { |e| e.groups << group })
    end
  end


  context 'index_participations_details on event in group ' do

    let(:group) { groups(:be_board) }
    context 'FederalBoard::Member' do
      let(:user) { people(:top_leader) }

      it 'is allowed because of :layer_and_below_full' do
        is_expected.to be_able_to(:index_participations_details, event)
      end
    end

    context 'State::GroupAdmin' do
      let(:role) { Fabricate(Group::StateBoard::Leader.name, group: group) }

      it 'is allowed because of :group_full' do
        is_expected.to be_able_to(:index_participations_details, event)
      end
    end

    context 'Flock::Leader' do
      let(:user) { people(:flock_leader) }

      it 'with leader role is allowed' do
        create(Event::Role::Leader)

        is_expected.to be_able_to(:index_participations_details, event)
      end

      it 'with participation role is not allowed' do
        create(Event::Role::Participant,)

        is_expected.not_to be_able_to(:index_participations_details, event)
      end

      def create(event_role_type)
        participation = Fabricate(:event_participation, person: user, event: event)
        Fabricate(event_role_type.name, participation: participation)
      end

    end
  end

  context 'Coach' do

    let(:person)  { Fabricate(:person) }
    let(:event)   { Fabricate(:camp, coach_id: person.id).reload }

    subject { Ability.new(person.reload) }

    it 'may read participants when coaching' do
      is_expected.to be_able_to(:index_participations, event)
    end

    it 'may not read participants when not coaching' do
      event = Fabricate(:camp, coach_id: '')
      is_expected.not_to be_able_to(:index_participations, event)
    end
     
  end

end
