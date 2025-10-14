#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::ParticipationsController
  extend ActiveSupport::Concern

  prepended do
    sort_mappings_with_indifferent_access
      .merge!(originating_state: {
        order: "originating_states_people.name AS originating_state_order_statement",
        order_alias: "originating_state_order_statement"
      })
      .merge!(originating_flock: {
        order: "originating_flocks_people.name AS originating_flock_order_statement",
        order_alias: "originating_flock_order_statement"
      })
  end

  def entries_scope
    super
      # rubocop:todo Layout/LineLength
      .joins("LEFT JOIN groups originating_flocks_people ON originating_flocks_people.id = people.originating_flock_id LEFT JOIN group_translations translations_originating_flocks ON translations_originating_flocks.group_id = originating_flocks_people.id")
      # rubocop:enable Layout/LineLength
      # rubocop:todo Layout/LineLength
      .joins("LEFT JOIN groups originating_states_people ON originating_states_people.id = people.originating_state_id LEFT JOIN group_translations translations_originating_states ON translations_originating_states.group_id = originating_states_people.id")
    # rubocop:enable Layout/LineLength
  end
end
