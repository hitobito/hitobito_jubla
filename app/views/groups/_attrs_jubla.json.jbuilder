#  Copyright (c) 2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

json.extract!(entry,
              *entry.used_attributes(:parish, :founding_year, :unsexed, :bank_account,
                                     :clairongarde, :jubla_insurance, :jubla_full_coverage,
                                     :coach_id, :advisor_id))
