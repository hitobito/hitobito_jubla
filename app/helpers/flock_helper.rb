# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module FlockHelper
  
  def format_group_advisor_id(group)
    if group.advisor_id
      assoc_link(group.advisor)
    else
      '(Niemand)'
    end
  end
  
  def format_group_coach_id(group)
    if group.coach_id
      assoc_link(group.coach)
    else
      '(Niemand)'
    end
  end
end