# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Event::Course::Condition < ActiveRecord::Base

  belongs_to :group

  validate :assert_group_can_have_courses


  def to_s
    label
  end

  private

  def assert_group_can_have_courses
    if group && !group.event_types.include?(Event::Course)
      errors.add(:group_id, 'muss Kurse anbieten können')
    end
  end
end
