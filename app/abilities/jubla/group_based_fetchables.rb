#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::GroupBasedFetchables
  extend ActiveSupport::Concern

  included do
    alias_method_chain :append_group_conditions, :alumnus
  end

  def append_group_conditions_with_alumnus(condition)
    append_group_conditions_without_alumnus(condition)
    visible_alumnus_from_above(condition)
  end

  private

  def visible_alumnus_from_above(condition)
    alumnus_leader_layers.each do |g|
      condition.or('groups.lft >= ? AND
                   groups.rgt <= ? AND
                   groups.type IN (?)', g.lft, g.rgt, Group::AlumnusGroup.descendants)
    end
  end

  def alumnus_leader_layers
    @alumnus_leader_layers ||= Group.where(id: layer_group_ids_with_permissions(:alumnus_below_full))
  end
end
