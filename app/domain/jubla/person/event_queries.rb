# encoding: utf-8

#  Copyright (c) 2012-2015, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla
  module Person::EventQueries
    extend ActiveSupport::Concern

    def coached_events
      person.events.
        uptoamonthago.
        merge(::Event::Participation.active).
        joins(participations: :roles).
        where(event_roles: {type: ['Event::Camp::Role::Coach', 'Event::Course::Role::Advisor']}).
        uniq.
        includes(:groups).
        preload_all_dates.
        order_by_date
    end
  end
end
