# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::ParticipationsController
  extend ActiveSupport::Concern

  included do
    alias_method_chain :load_entries, :origins
  end

  def load_entries_with_origins
    load_entries_without_origins.
      includes(person: [:originating_flock, :originating_state])
  end
end
