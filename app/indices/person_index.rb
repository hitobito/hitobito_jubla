#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module PersonIndex; end

ThinkingSphinx::Index.define_partial :person do
  indexes name_mother, name_father, nationality, profession, bank_account,
    ahv_number_old, insurance_company, insurance_number
end
