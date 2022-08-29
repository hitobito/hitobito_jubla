#  Copyright (c) 2022, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::EventsHelper
  extend ActiveSupport::Concern

  included do
    def course_groups
      return Group.course_offerers if can?(:list_all, Event::Course) || current_user.leader_user?

      Group.course_offerers.where(id: current_user.groups_hierarchy_ids)
    end
  end

end
