#  Copyright (c) 2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

json.extract!(entry, :nationality, :profession, :name_mother, :name_father)

if show_full
  json.extract!(entry, :bank_account, :ahv_number, :ahv_number_old, :j_s_number,
                       :insurance_company, :insurance_number)
end