# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Event::Course::ConditionAbility < AbilityDsl::Base

  include AbilityDsl::Constraints::Group

  on(Event::Course::Condition) do
    permission(:layer_full).may(:manage).in_same_layer_or_below
  end

end
