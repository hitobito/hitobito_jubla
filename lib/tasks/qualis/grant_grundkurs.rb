# frozen_string_literal: true

#  Copyright (c) 2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Qualis
  # Retroactively grants the Grundkurs qualification to everybody who attended a
  # Grundkurs (GK J+S or GK BSV) since 2002 (jubla#268).
  class GrantGrundkurs
    ATTENDED_SINCE = Date.new(2002, 1, 1)

    def initialize(target_kind_id:, event_kind_ids:, dry_run: false)
      @target_kind = QualificationKind.find(target_kind_id)
      @event_kinds = Event::Kind.where(id: event_kind_ids).to_a
      if @event_kinds.size != event_kind_ids.size
        raise ActiveRecord::RecordNotFound, "unknown event kinds"
      end

      @dry_run = dry_run
    end

    def run
      Qualification.transaction do
        say("Dry run, all changes will be rolled back") if @dry_run
        attended = courses
        created = say_with_time("Granting #{@target_kind.label} qualifications from " \
                                "#{attended.size} courses") do
          attended.sum { |course| grant(course) }
        end
        say("Created #{created} #{@target_kind.label} qualifications " \
            "from #{attended.size} courses")
        raise ActiveRecord::Rollback if @dry_run
      end
    end

    private

    # Oldest course first, so people that attended several get the earliest date.
    # Sorted in ruby because qualification_date is derived from the event dates.
    def courses
      Event::Course
        .where(kind_id: @event_kinds.map(&:id))
        .joins(:dates)
        .where(event_dates: {start_at: ATTENDED_SINCE..})
        .distinct
        .includes(:dates, :translations)
        .sort_by(&:qualification_date)
    end

    def grant(course)
      person_ids = participant_ids(course)
        .reject { |person_id| people_with_qualification.include?(person_id) }
      person_ids.each { |person_id| create(person_id, course) }
      people_with_qualification.merge(person_ids)
      person_ids.size
    end

    def people_with_qualification
      @people_with_qualification ||=
        Qualification.where(qualification_kind_id: @target_kind.id).pluck(:person_id).to_set
    end

    def participant_ids(course)
      course.participations
        .where(participant_type: Person.sti_name)
        .joins(:roles)
        .where(event_roles: {type: Event::Course.participant_types.map(&:sti_name)})
        .distinct
        .pluck(:participant_id)
    end

    # create! rather than insert_all: finish_at, validations and PaperTrail
    # versions then behave exactly as when a qualification is added in the UI.
    def create(person_id, course)
      Qualification.create!(person_id: person_id,
        qualification_kind: @target_kind,
        start_at: course.qualification_date,
        qualified_at: course.qualification_date,
        origin: course.to_s)
    end

    def say_with_time(message)
      say(message)
      result = nil
      elapsed = ActiveSupport::Benchmark.realtime { result = yield }
      say("%.4fs" % elapsed, true)
      say("#{result} rows", true) if result.is_a?(Integer)
      result
    end

    def say(message, subitem = false)
      puts "#{subitem ? "   ->" : "--"} #{message}" # rubocop:disable Rails/Output
    end
  end
end
