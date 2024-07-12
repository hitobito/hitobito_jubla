#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::ParticipationDecorator
  extend ActiveSupport::Concern

  included do
    alias_method_chain :person_location_information, :origins
  end

  def person_location_information_with_origins
    origins = [person.originating_state, person.originating_flock].compact
    origins.empty? ? person_location_information_without_origins : origins.join(", ")
  end
end
