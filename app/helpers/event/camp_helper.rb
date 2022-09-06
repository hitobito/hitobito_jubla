# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Event::CampHelper
  def format_event_advisor_id(_event)
    person_link(entry.advisor)
  end

  def format_event_coach_id(_event)
    person_link(entry.coach)
  end

  def camp_list_permitting_states
    roles = current_user.roles.select do |role|
      EventAbility::STATE_CAMP_LIST_ROLES.any? { |t| role.is_a?(t) }
    end
    roles.collect { |r| r.group.layer_group }.uniq.sort_by(&:to_s)
  end
end
