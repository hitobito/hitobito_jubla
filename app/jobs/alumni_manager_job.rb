# frozen_string_literal: true

#  Copyright (c) 2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class AlumniManagerJob < RecurringJob
  run_every 1.day

  APPLICABLE_ROLE_TYPES = Alumni::APPLICABLE_ROLE_TYPES.map(&:sti_name)

  def perform_internal
    scope = Role
      .ended_or_archived
      .where(type: APPLICABLE_ROLE_TYPES, alumni_processed: false)

    scope.find_each do |role|
      role.alumnus_manager.create
    end
  end

  def next_run
    interval.from_now.midnight + 1.minute
  end
end
