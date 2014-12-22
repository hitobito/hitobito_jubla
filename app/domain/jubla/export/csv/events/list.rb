# encoding: utf-8

#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.


module Jubla::Export::Csv::Events
  module List
    extend ActiveSupport::Concern

    included do
      alias_method_chain :build_attribute_labels, :advisor
      alias_method_chain :contactable_keys, :j_s_number
      alias_method_chain :translated_prefix, :advisor
    end

    private

    def build_attribute_labels_with_advisor
      build_attribute_labels_without_advisor.tap do |labels|
        add_prefixed_contactable_labels(labels, :advisor)
      end
    end

    def contactable_keys_with_j_s_number
      contactable_keys_without_j_s_number.push(:j_s_number)
    end

    def translated_prefix_with_advisor(prefix)
      prefix == :advisor ?  'LKB' : translated_prefix_without_advisor(prefix)
    end
  end
end
