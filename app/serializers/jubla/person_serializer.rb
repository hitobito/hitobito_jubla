# encoding: utf-8

#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::PersonSerializer
  extend ActiveSupport::Concern

  included do
    extension(:details) do |options|
      map_properties :nationality, :profession, :name_mother, :name_father

      if options[:show_full]
        map_properties :bank_account, :ahv_number_old,
                       :insurance_company, :insurance_number
      end
    end
  end

end
