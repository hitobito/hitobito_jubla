#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::EventParticipationsHelper
  def event_participation_table_options(t, event:, group:)
    if can?(:index_full_participations, event)
      t.col(t.sort_header(:originating_state,
        Person.human_attribute_name(:originating_state))) { |p|
        p.model.person.originating_state.to_s
      }
      t.col(t.sort_header(:originating_flock,
        Person.human_attribute_name(:originating_flock))) { |p|
        p.model.person.originating_flock.to_s
      }
    end
  end
end
