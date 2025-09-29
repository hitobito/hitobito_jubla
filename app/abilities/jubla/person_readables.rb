#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::PersonReadables
  extend ActiveSupport::Concern

  included do
    alias_method_chain :read_permission_for_this_group?, :alumnus
  end

  def read_permission_for_this_group_with_alumnus?
    read_permission_for_this_group_without_alumnus? ||
      group_read_for_alumnus_leader?
  end

  private

  def group_read_for_alumnus_leader?
    if group.alumnus? && alumnus_leader_layer_ids.present?
      (alumnus_leader_layer_ids & group.layer_hierarchy.collect(&:id)).present?
    end
  end

  def alumnus_leader_layer_ids
    @alumnus_leader_layer_ids ||= layer_group_ids_with_permissions(:alumnus_below_full)
  end
end
