# encoding: utf-8

#  Copyright (c) 2012-2018, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::Group::Mover
  extend ActiveSupport::Concern

  included do
    alias_method_chain :candidates, :alumnus_check
  end

  def candidates_with_alumnus_check
    return [] if group.siblings.where(type: Group::ALUMNI_GROUPS_CLASSES).empty?
    candidates_without_alumnus_check
  end
end
