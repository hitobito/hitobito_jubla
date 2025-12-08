#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Export::Tabular
  class CensusFlockFederation < Export::Tabular::Base
    class Row < Export::Tabular::Row
      def value_for(attr)
        entry.fetch(attr)
      end
    end

    self.model_class = Group::Flock
    self.row_class = Row

    private

    def build_attribute_labels
      {
        state: "Kanton",
        region: "Region",
        kind: "Art",
        name: "Schar",
        leader_count: "Leitende",
        child_count: "Kinder"
      }
    end
  end
end
