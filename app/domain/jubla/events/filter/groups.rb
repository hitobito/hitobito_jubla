#  Copyright (c) 2022, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Events::Filter::Groups
  extend ActiveSupport::Concern

  included do
    def to_scope
      scope = @scope
      scope = scope.in_hierarchy(@user) unless complete_course_list_allowed?
      scope = scope.with_group_id(group_ids_in_hierarchy) if group_ids.any?

      if @user.leader_user?
        scope = scope.or(Event.where(globally_visible: true).distinct) if group_ids.empty?
        scope = scope.or(globally_visible_events_outside_hierarchy) if group_ids_outside_hierarchy.any? # rubocop:disable Metrics/LineLength
      end

      scope
    end

    def globally_visible_events_outside_hierarchy
      Event.where(id: events_in_groups(group_ids_outside_hierarchy),
                  globally_visible: true).distinct
    end

    def group_ids_in_hierarchy
      @group_ids_in_hierarchy ||= group_ids.select do |g_id|
        @user.groups_hierarchy_ids.include? g_id.to_i
      end
    end

    def group_ids_outside_hierarchy
      @group_ids_outside_hierarchy ||= group_ids - group_ids_in_hierarchy
    end

    def events_in_groups(group_ids)
      Event.with_group_id(group_ids).pluck(:id)
    end
  end
end
