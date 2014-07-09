module Jubla::PersonSerializer
  extend ActiveSupport::Concern

  included do
    extension(:details) do |options|
      map_properties :nationality, :profession, :name_mother, :name_father

      if options[:show_full]
        map_properties :bank_account, :ahv_number, :ahv_number_old, :j_s_number,
                       :insurance_company, :insurance_number
      end
    end
  end

end