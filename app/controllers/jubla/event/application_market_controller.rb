# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::ApplicationMarketController
  extend ActiveSupport::Concern

  included do
    alias_method_chain :load_participants, :origins
    alias_method_chain :load_applications, :origins
  end

  private

  def load_participants_with_origins
    load_participants_without_origins.includes(person: [:originating_flock,
                                                        :originating_state])
  end

  def load_applications_with_origins
    load_applications_without_origins.includes(person: [:originating_flock,
                                                        :originating_state])
  end
end
