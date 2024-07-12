# frozen_string_literal: true

#  Copyright (c) 2012-2023, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::PersonAbility
  extend ActiveSupport::Concern

  include Jubla::RoleAbility

  STATES = %w[application_open application_closed assignment_closed completed].freeze

  included do
    on(Person) do
      permission(:layer_and_below_full).may(:update)
        .non_restricted_in_same_layer_or_visible_below_or_accessible_participations
      permission(:alumnus_below_full).may(:show, :show_full, :show_details, :update)
        .in_child_alumnus_group

      permission(:layer_and_below_full).may(:change_managers)
        .non_restricted_in_same_layer_or_visible_below_or_accessible_participations_except_self
      permission(:alumnus_below_full).may(:change_managers)
        .in_child_alumnus_group_except_self
    end
  end

  def non_restricted_in_same_layer_or_visible_below_or_accessible_participations
    non_restricted_in_same_layer_or_visible_below || accessible_participations
  end

  def non_restricted_in_same_layer_or_visible_below_or_accessible_participations_except_self
    non_restricted_in_same_layer_or_visible_below_or_accessible_participations && !herself
  end

  def accessible_participations
    events_with_valid_states.any? do |event|
      (user_context.permission_layer_ids(:layer_and_below_full) & event.group_ids).present?
    end
  end

  def in_child_alumnus_group
    roles = Role.joins(:group).where(person_id: person.id,
      groups: {type: Group::AlumnusGroup.descendants})

    if alumnus_leader_layer_ids.present?
      layer_hierarchy_ids = roles.collect { |r| r.group.layer_hierarchy.collect(&:id) }.flatten
      (alumnus_leader_layer_ids & layer_hierarchy_ids).present?
    end
  end

  def in_child_alumnus_group_except_self
    in_child_alumnus_group && !herself
  end

  private

  def events_with_valid_states
    subject
      .event_participations
      .includes(:event)
      .collect(&:event)
      .select { |event| STATES.include?(event.state) }
  end
end
