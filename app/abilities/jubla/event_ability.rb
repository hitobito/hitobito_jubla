# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::EventAbility
  extend ActiveSupport::Concern

  include Jubla::EventConstraints

  STATE_CAMP_LIST_ROLES = [Group::State::Coach,
                           Group::State::GroupAdmin,
                           Group::StateAgency::Leader,
                           Group::StateAgency::GroupAdmin].freeze

  included do
    on(Event) do
      general(:update, :destroy, :application_market, :qualify).
        at_least_one_group_not_deleted_and_not_closed_or_admin


      permission(:any).may(:update).for_managed_events

      permission(:any).may(:index_participations_details).for_leaded_events
      permission(:group_full).may(:index_participations_details).in_same_group
      permission(:group_and_below_full).may(:index_participations_details).in_same_group_or_below
      permission(:layer_full).may(:index_participations_details).in_same_layer
      permission(:layer_and_below_full).may(:index_participations_details).in_same_layer_or_below
    end

    on(Event::Camp) do
      class_side(:list_all_camps).if_it_support_or_federal_board_member
      class_side(:list_state_camps).if_state_camp_list_role
    end
  end

  def for_managed_events
    permission_in_event?(:event_full) && permission_in_event?(:qualify)
  end

  def if_it_support_or_federal_board_member
    it_support? || federal_board_member?
  end

  def if_state_camp_list_role
    role_type?(*STATE_CAMP_LIST_ROLES)
  end

  def it_support?
    role_type?(Group::Federation::ItSupport)
  end

  def federal_board_member?
    role_type?(Group::FederalBoard::Member)
  end

end
