# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::RoleAbility
  extend ActiveSupport::Concern

  included do
    on(Role) do
      permission(:alumnus_below_full).
        may(:update, :create, :destroy, :show).in_child_alumnus_group
    end

  end

  def in_child_alumnus_group
    if group.alumnus? && alumnus_leader_layer_ids.present?
      (alumnus_leader_layer_ids & group.layer_hierarchy.collect(&:id)).present?
    end
  end

  private

  def alumnus_leader_layer_ids
    @alumnus_leader_layer_ids ||=
      groups_with_permissions(:alumnus_below_full).collect(&:layer_group).uniq.collect(&:id)
  end

  def groups_with_permissions(*permissions)
    permissions.collect { |p| user.groups_with_permission(p) }
               .flatten
               .uniq
  end

end
