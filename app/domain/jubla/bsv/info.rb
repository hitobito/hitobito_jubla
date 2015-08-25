# encoding: utf-8

#  Copyright (c) 2012-2015, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla
  module Bsv::Info
    extend ActiveSupport::Concern

    included do
      alias_method :participant_count, :participant_aged_17_to_30_count
      alias_method :location, :max_date_location_or_location
    end

    def total_day_count
      course.dates.map(&:duration).map(&:days).reduce(&:+)
    end

    def cook_count
      participations_for([::Event::Role::Cook]).count
    end

    def speaker_count
      participations_for([::Event::Role::Speaker]).count
    end

    def participant_aged_17_to_30_count
      participants_aged_17_to_30.count
    end

    def total_participant_count
      participants.count
    end

    def total_leader_count
      participations_for(roles_without_participants_and_advisors).count
    end

    def warnings
      { participant_count: participants.any? { |p| p.person.birthday.blank? },
        canton_count: participants.any? { |p| !ch_resident?(p.person) } }
    end

    def error(key)
      { participant_count: 'Nicht alle Teilnehmer haben den Geburtstag gestetzt.',
        canton_count: 'Nicht alle Teilnehmer haben einen gültigen Kanton gesetzt.' }.fetch(key)
    end

    def max_date_location_or_location
      max_duration_date ? max_duration_date.location : course.location
    end

    private

    def roles_without_participants_and_advisors
      course.role_types - course.participant_types - [::Event::Course::Role::Advisor]
    end

    def max_duration_date
      @max_duration_date ||= course.dates.
        select { |date| date.location.present? }.
        max { |a, b| a.duration.days <=> b.duration.days }
    end
  end
end
