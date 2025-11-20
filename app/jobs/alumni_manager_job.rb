# frozen_string_literal: true

#  Copyright (c) 2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class AlumniManagerJob < RecurringJob
  run_every 1.day

  APPLICABLE_ROLE_TYPES = Alumni::APPLICABLE_ROLE_TYPES.map(&:sti_name)

  def perform_internal
    destroy_obsolete
    create_missing
  end

  def create_missing
    alumni = Person.joins(:roles).merge(Role.alumnus_members).distinct
    inactive = Role.ended_or_archived.where(type: APPLICABLE_ROLE_TYPES)
    inactive.where.not(person_id: alumni).find_each do |role|
      Jubla::Role::AlumnusManager.new(role).create
    end
  end

  def destroy_obsolete
    active = Person.joins(:roles).merge(Role.where(type: APPLICABLE_ROLE_TYPES)).distinct
    Role.alumnus_members.without_archived.where(person_id: active).find_each do |role|
      Jubla::Role::AlumnusManager.new(role).destroy
    end
  end

  def next_run
    interval.from_now.midnight + 1.minute
  end
end
