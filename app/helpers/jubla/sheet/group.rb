# encoding: utf-8

#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_pbs and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_pbs.

module Jubla::Sheet::Group
  extend ActiveSupport::Concern

  included do
    self.tabs.insert(-2,
      Sheet::Tab.new(:tab_population_label,
                     :population_group_path,
                     if: ->(view, group) do
                       group.kind_of?(Group::Flock) && view.can?(:approve_population, group)
                     end),

      Sheet::Tab.new('group.tabs.statistics',
                     :census_evaluation_path,
                     alt: [:censuses_tab_path, :group_member_counts_path],
                     if: ->(view, group) do
                       group.census? && view.can?(:evaluate_census, group)
                     end),

      Sheet::Tab.new('activerecord.models.event/course/condition.other',
                     :group_event_course_conditions_path,
                     if: ->(view, group) do
                       group.event_types.include?(Event::Course) &&
                       view.can?(:index_event_course_conditions, group)
                     end))
  end
end