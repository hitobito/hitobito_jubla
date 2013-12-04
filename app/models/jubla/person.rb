# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Person
  extend ActiveSupport::Concern

  included do
    attr_accessible :name_mother, :name_father, :nationality, :profession, :bank_account,
                    :ahv_number, :ahv_number_old, :j_s_number, :insurance_company, :insurance_number

    define_partial_index do
      indexes name_mother, name_father, nationality, profession, bank_account,
              ahv_number, ahv_number_old, j_s_number, insurance_company, insurance_number
    end
  end

  module ClassMethods

  end

end
