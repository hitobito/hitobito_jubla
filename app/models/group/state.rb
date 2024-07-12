#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

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

# Ebene Kanton
class Group::State < Group
  self.layer = true
  self.default_children = [Group::StateAgency, Group::StateBoard, Group::StateAlumnusGroup]
  self.contact_group_type = Group::StateAgency
  self.event_types = [Event, Event::Course]

  self.used_attributes += [:jubla_property_insurance, :jubla_liability_insurance,
    :jubla_full_coverage]
  self.superior_attributes += [:jubla_property_insurance, :jubla_liability_insurance,
    :jubla_full_coverage]

  has_many :member_counts

  class Coach < Jubla::Role::Coach
  end

  class GroupAdmin < Jubla::Role::GroupAdmin
  end

  class Alumnus < Jubla::Role::Alumnus
  end

  class External < Jubla::Role::External
  end

  class DispatchAddress < Jubla::Role::DispatchAddress
  end

  roles Coach, GroupAdmin, Alumnus, External, DispatchAddress

  children Group::StateAgency,
    Group::StateBoard,
    Group::StateProfessionalGroup,
    Group::StateWorkGroup,
    Group::Region,
    Group::Flock,
    Group::StateAlumnusGroup

  def census_total(year)
    MemberCount.total_by_states(year).find_by(state_id: id)
  end

  def census_groups(year)
    MemberCount.total_by_flocks(year, self)
  end

  def census_details(year)
    MemberCount.details_for_state(year, self)
  end
end
