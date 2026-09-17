#  Copyright (c) 2012-2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::GroupAbility
  extend ActiveSupport::Concern

  included do
    on(Group) do
      permission(:any).may(:evaluate_census).if_member
      permission(:layer_and_below_read).may(:export_census).in_same_layer_or_below

      permission(:layer_and_below_full)
        .may(:index_event_course_conditions)
        .in_same_layer_or_below

      permission(:layer_and_below_full)
        .may(:remind_census, :approve_population, :create_member_counts)
        .in_same_layer_or_below

      permission(:layer_and_below_full)
        .may(:update_member_counts, :delete_member_counts)
        .in_same_layer_or_below_if_ast_or_bulei

      permission(:any).may(:"index_event/camps").all
      permission(:group_full).may(:"export_event/camps").in_same_group
      permission(:group_and_below_full).may(:"export_event/camps").in_same_group_or_below
      permission(:layer_read).may(:"export_event/camps").in_same_layer
      permission(:layer_and_below_read).may(:"export_event/camps").in_same_layer_or_below

      # Event templates may only be managed by an admin, even though ordinary
      # layer permission (granted in core) would otherwise allow it.
      general(:index_event_templates).if_admin
    end
  end

  def in_same_layer_or_below_if_ast_or_bulei
    in_same_layer_or_below &&
      user.roles.any? do |r|
        r.is_a?(Group::StateAgency::Leader) ||
          r.is_a?(Group::FederalBoard::Member)
      end
  end

  def if_admin
    user_context.admin
  end
end
