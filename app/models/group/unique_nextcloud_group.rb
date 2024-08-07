# frozen_string_literal: true

#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Group::UniqueNextcloudGroup
  extend ActiveSupport::Concern

  included do
    self.nextcloud_group = :calculate_nextcloud_group
  end

  def calculate_nextcloud_group
    {
      "gid" => "#{group_id}_#{type}",
      "displayName" => "#{group.name} - #{self.class.model_name.human(count: 2)}"
    }
  end
end
