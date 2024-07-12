#  Copyright (c) 2012-2015, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla
  module Person::EventQueries
    extend ActiveSupport::Concern

    included do
      alias_method_chain :upcoming_events, :coached
    end

    def coached_events
      person.events
        .up_to_a_month_ago
        .merge(::Event::Participation.active)
        .joins(participations: :roles)
        .where(event_roles: {type: [::Event::Camp::Role::Coach.sti_name,
          ::Event::Course::Role::Advisor.sti_name]})
        .distinct
        .includes(:groups)
        .preload_all_dates
        .order_by_date
    end

    def upcoming_events_with_coached
      upcoming_events_without_coached
        .joins("INNER JOIN event_roles ON event_roles.participation_id = event_participations.id")
        .where.not(event_roles: {type: [::Event::Camp::Role::Coach.sti_name,
          ::Event::Course::Role::Advisor.sti_name]})
    end
  end
end
