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
      general(:update, :destroy, :application_market, :qualify)
        .at_least_one_group_not_deleted_and_not_closed_or_admin

      permission(:any).may(:update).for_managed_events

      permission(:any).may(:index_full_participations).for_leaded_events
    end

    on(Event::Camp) do
      class_side(:list_all_camps).if_it_support_or_federal_board_member
      class_side(:list_state_camps).if_state_camp_list_role
    end

    alias_method_chain :if_layer_and_below_full_on_root, :superstructure
  end

  def if_layer_and_below_full_on_root_with_superstructure
    user_context.permission_layer_ids(:layer_and_below_full).include?(Group::Federation.first.id)
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
