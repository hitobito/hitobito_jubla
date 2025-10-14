#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Person
  extend ActiveSupport::Concern

  included do
    belongs_to :originating_flock, class_name: "Group"
    belongs_to :originating_state, class_name: "Group"

    # rubocop:todo Layout/LineLength
    Person::SEARCHABLE_ATTRS << :name_mother << :name_father << :nationality << :profession << :bank_account <<
      # rubocop:enable Layout/LineLength
      :insurance_company << :insurance_number
  end

  module ClassMethods
    def alumnus_only
      joins(:roles)
        .merge(Role.alumnus)
        .where.not(id: joins(:roles).merge(Role.without_alumnus))
        .distinct
    end
  end

  def alumnus_only?
    self.class.alumnus_only.where(id: id).exists?
  end

  def canton
    self[:canton].presence || super
  end
end
