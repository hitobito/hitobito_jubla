#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::ParticipationsController
  extend ActiveSupport::Concern

  # both originating_state and originating_flock reference a group
  #
  # when associations are included in participation_filter AR uses
  # the groups table name for the first included association (flocks)
  # and aliases the table name for the second association (states)
  prepended do
    sort_mappings_with_indifferent_access
      .merge!(originating_state: "originating_states_people.name",
        originating_flock: "originating_flocks_people.name")
  end

  def list_entries
    super
      .includes(person: [originating_flock: :translations, originating_state: :translations])
  end
end
