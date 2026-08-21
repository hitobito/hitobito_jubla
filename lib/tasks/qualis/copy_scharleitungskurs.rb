# frozen_string_literal: true

#  Copyright (c) 2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Qualis
  # Gives everybody who ever received the source qualification (Zusatz Scharleitung)
  # the target qualification (Scharleitungskurs) as well (jubla#268).
  class CopyScharleitungskurs
    def initialize(source_kind_id:, target_kind_id:, dry_run: false)
      @source_kind = QualificationKind.find(source_kind_id)
      @target_kind = QualificationKind.find(target_kind_id)
      @dry_run = dry_run
    end

    def run
      Qualification.transaction do
        say("Dry run, all changes will be rolled back") if @dry_run
        dates = start_dates
        say_with_time("Creating #{@target_kind.label} qualifications for " \
                      "#{dates.size} people with #{@source_kind.label}") do
          dates.each { |person_id, start_at| create(person_id, start_at) }
          dates.size
        end
        raise ActiveRecord::Rollback if @dry_run
      end
    end

    private

    # Latest start_at per person, as that is the one shown in the UI for
    # qualifications without expiry. People already holding the target are left alone.
    def start_dates
      Qualification
        .where(qualification_kind_id: @source_kind.id)
        .where.not(person_id: Qualification.where(qualification_kind_id: @target_kind.id)
                                           .select(:person_id))
        .group(:person_id)
        .maximum(:start_at)
    end

    # create! rather than insert_all: finish_at, validations and PaperTrail
    # versions then behave exactly as when a qualification is added in the UI.
    def create(person_id, start_at)
      Qualification.create!(person_id: person_id,
        qualification_kind: @target_kind,
        start_at: start_at,
        qualified_at: start_at,
        origin: "Übernommen von #{@source_kind.label}")
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
