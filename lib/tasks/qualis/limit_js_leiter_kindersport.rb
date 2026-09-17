# frozen_string_literal: true

#  Copyright (c) 2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Qualis
  # Expires the J+S Leiter*in LS/T Kindersport qualification at the end of 2026,
  # for everybody whose qualification would last longer (jubla#268).
  class LimitJsLeiterKindersport
    FINISH_AT = Date.new(2026, 12, 31)

    def initialize(kind_id:, dry_run: false)
      @kind = QualificationKind.find(kind_id)
      @dry_run = dry_run
    end

    def run
      Qualification.transaction do
        say("Dry run, all changes will be rolled back") if @dry_run
        say_with_time("Ending #{too_late.count} #{@kind.label} qualifications " \
                      "on #{FINISH_AT}") do
          too_late.update_all(finish_at: FINISH_AT)
        end
        raise ActiveRecord::Rollback if @dry_run
      end
    end

    private

    def too_late
      Qualification
        .where(qualification_kind_id: @kind.id)
        .where("finish_at > ? OR finish_at IS NULL", FINISH_AT)
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
