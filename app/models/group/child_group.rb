# == Schema Information
#
# Table name: groups
#
#  id                          :integer          not null, primary key
#  parent_id                   :integer
#  lft                         :integer
#  rgt                         :integer
#  name                        :string(255)      not null
#  short_name                  :string(31)
#  type                        :string(255)      not null
#  email                       :string(255)
#  address                     :string(1024)
#  zip_code                    :integer
#  town                        :string(255)
#  country                     :string(255)
#  contact_id                  :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  deleted_at                  :datetime
#  layer_group_id              :integer
#  creator_id                  :integer
#  updater_id                  :integer
#  deleter_id                  :integer
#  require_person_add_requests :boolean          default(FALSE), not null
#  bank_account                :string(255)
#  jubla_liability_insurance   :boolean          default(FALSE), not null
#  jubla_full_coverage         :boolean          default(FALSE), not null
#  parish                      :string(255)
#  kind                        :string(255)
#  unsexed                     :boolean          default(FALSE), not null
#  clairongarde                :boolean          default(FALSE), not null
#  founding_year               :integer
#  jubla_property_insurance    :boolean          default(FALSE), not null
#

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Kindergruppe
class Group::ChildGroup < Group
  class Leader < Jubla::Role::Leader
    self.permissions = [:group_full]
  end

  class Child < ::Role
    self.permissions = [:group_read]
    self.visible_from_above = false
  end

  class GroupAdmin < Jubla::Role::GroupAdmin
  end

  class Alumnus < Jubla::Role::Alumnus
  end

  class External < Jubla::Role::External
  end

  class DispatchAddress < Jubla::Role::DispatchAddress
  end

  roles Leader, Child, GroupAdmin, Alumnus, External, DispatchAddress
end
