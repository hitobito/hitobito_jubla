# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::PersonDecorator
  extend ActiveSupport::Concern

  def active_roles_grouped
    build_memo(active_roles)
  end

  def inactive_roles_grouped
    build_memo(active_roles.deleted.to_a.select(&:alumnus_applicable?))
  end

  def coached_events
    @coached_events ||= EventDecorator.decorate_collection(event_queries.coached_events)
  end

  private

  def active_roles
    roles.includes(:group).without_alumnus
  end

  def build_memo(roles)
    roles.each_with_object(Hash.new { |h, k| h[k] = [] }) do |role, memo|
      memo[role.group] << role
    end
  end
end
