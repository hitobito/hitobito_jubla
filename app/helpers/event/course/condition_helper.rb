#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Event::Course::ConditionHelper
  def format_event_course_condition_content(condition)
    condition.content.to_plain_text.truncate(100)
  end
end
