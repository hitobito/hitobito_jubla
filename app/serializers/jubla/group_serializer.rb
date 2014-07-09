module Jubla::GroupSerializer
  extend ActiveSupport::Concern

  included do
    extension(:attrs) do |_|
      map_properties(*item.used_attributes(:parish, :founding_year, :unsexed, :bank_account,
                                           :clairongarde, :jubla_insurance, :jubla_full_coverage,
                                           :coach_id, :advisor_id))
    end
  end

end