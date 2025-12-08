#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Export::Tabular
  class CensusFlock < Export::Tabular::Base
    class Row < Export::Tabular::Row
      def value_for(attr)
        entry.fetch(attr)
      end
    end

    self.model_class = Group::Flock
    self.row_class = Row

    private

    def build_attribute_labels # rubocop:disable Metrics/MethodLength
      {
        state: "Kanton",
        region: "Region",
        kind: "Art",
        name: "Schar",
        contact_first_name: "Kontakt Vorname",
        contact_last_name: "Kontakt Nachname",
        address: human_attribute(:address),
        zip_code: human_attribute(:zip_code),
        town: human_attribute(:town),
        jubla_property_insurance: human_attribute(:jubla_property_insurance),
        jubla_liability_insurance: human_attribute(:jubla_liability_insurance),
        jubla_full_coverage: human_attribute(:jubla_full_coverage),
        leader_count: "Leitende",
        child_count: "Kinder"
      }
    end
  end
end
