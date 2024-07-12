#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_pbs and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_pbs.

module Jubla::Sheet::Group
  extend ActiveSupport::Concern

  included do
    tabs.insert(4,
      Sheet::Tab.new("activerecord.models.event/camp.other",
        :camp_group_events_path,
        params: {returning: true},
        if: lambda do |view, group|
          group.event_types.include?(::Event::Camp) &&
            view.can?(:"index_event/camps", group)
        end))

    tabs.insert(-2,
      Sheet::Tab.new(:tab_population_label,
        :population_group_path,
        if: lambda do |view, group|
          group.is_a?(Group::Flock) && view.can?(:approve_population, group)
        end),
      Sheet::Tab.new("Statistik",
        :census_evaluation_path,
        alt: [:censuses_tab_path, :group_member_counts_path],
        if: lambda do |view, group|
          group.census? && view.can?(:evaluate_census, group)
        end),
      Sheet::Tab.new("activerecord.models.event/course/condition.other",
        :group_event_course_conditions_path,
        if: lambda do |view, group|
          group.event_types.include?(Event::Course) &&
          view.can?(:index_event_course_conditions, group)
        end))
  end
end
