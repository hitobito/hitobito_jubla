#  Copyright (c) 2012-2015, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Export::Tabular::Events
  module BsvList
    extend ActiveSupport::Concern

    included do
      alias_method_chain :attribute_labels, :jubla
    end

    def attribute_labels_with_jubla
      attribute_labels_without_jubla
        .merge(total_day_count: "Kurstage",
          total_participant_count: "Teilnehmende Total",
          total_leader_count: "Leitungsteam Total",
          cook_count: "Küchenteam",
          speaker_count: "Referenten")
    end
  end
end
