# encoding: utf-8

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
  included do
    sort_mappings_with_indifferent_access.
      merge!(originating_state: null_safe_sort('originating_states_people.name'),
             originating_flock: null_safe_sort('groups.name'))

    alias_method_chain :append_mailing_instructions?, :signature
  end


  # only render instructions if signature flag is set
  def append_mailing_instructions_with_signature?
    append_mailing_instructions_without_signature? && event.signature?
  end

end
