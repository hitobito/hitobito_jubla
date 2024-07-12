#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::GroupSerializer
  extend ActiveSupport::Concern

  included do
    extension(:attrs) do |_|
      map_properties(*item.used_attributes(:parish, :founding_year, :unsexed, :bank_account,
        :clairongarde, :jubla_property_insurance,
        :jubla_liability_insurance, :jubla_full_coverage,
        :coach_id, :advisor_id, :kind))
    end
  end
end
