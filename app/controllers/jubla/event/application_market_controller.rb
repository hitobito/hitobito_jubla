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
    load_participants_without_origins
      .includes(participant: [:originating_flock, :originating_state])
  end

  # NOTE
  # underlying query is complex, we cannot simply include another relation
  # on participant, so we use two queries
  def load_applications_with_origins
    applications = Event::Participation
      .includes(:participant)
      .where(id: load_applications_without_origins.select(:id))

    Event::Participation::PreloadParticipations.preload(applications)
    applications
  end
end
