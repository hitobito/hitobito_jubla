# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Export::Csv
  module Events

    class JublaList < List

      private

      def build_attribute_labels
        super.merge(prefixed_contactable_labels(:advisor))
      end

      def contactable_keys
        super.push(:j_s_number)
      end

      def translated_prefix(prefix)
        prefix == :advisor ?  'LKB' : super
      end
    end

    class JublaRow < Row

      dynamic_attributes[/^advisor_/] = :contactable_attribute

      def advisor
        entry.advisor
      end
    end

    # Override the export method used in controller
    def self.export_list(courses)
      Export::Csv::Generator.new(Export::Events::JublaList.new(courses)).csv
    end

  end
end
