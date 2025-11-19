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

#  Copyright (c) 2012-2025, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Ebene Schar
class Group::Flock < JublaGroup
  include RestrictedRole

  self.layer = true
  self.default_children = [Group::FlockAlumnusGroup]
  self.event_types = [Event, Event::Camp]

  children Group::ChildGroup,
    Group::FlockAlumnusGroup

  AVAILABLE_KINDS = %w[Jungwacht Blauring Jubla].freeze

  self.used_attributes += [:bank_account, :parish, :kind, :unsexed, :clairongarde, :founding_year,
    :jubla_property_insurance, :jubla_liability_insurance,
    :jubla_full_coverage, :coach_id, :advisor_id]
  self.superior_attributes += [:jubla_property_insurance, :jubla_liability_insurance,
    :jubla_full_coverage, :coach_id, :advisor_id]

  has_many :member_counts

  validates :kind, inclusion: AVAILABLE_KINDS, allow_blank: true

  def available_coaches
    coach_role_types = [Group::State::Coach, Group::Region::Coach].collect(&:sti_name)
    Person.in_layer(*layer_hierarchy)
      .where(roles: {type: coach_role_types})
  end

  def available_advisors
    advisor_group_types = [Group::StateBoard, Group::RegionalBoard]
    advisor_role_types = advisor_group_types.collect(&:role_types).flatten.select(&:member?)
    Person.in_layer(*layer_hierarchy)
      .where(groups: {type: advisor_group_types.collect(&:sti_name)})
      .where(roles: {type: advisor_role_types.collect(&:sti_name)})
  end

  def to_s(format = :default)
    if attributes.include?("kind")
      [kind, super].compact.join(" ")
    else
      # if kind is not selected from the database, we end up here
      super
    end
  end

  def region
    ancestors.find_by(type: Group::Region.sti_name)
  end

  def state
    ancestors.find_by(type: Group::State.sti_name)
  end

  def census_groups(_year)
    []
  end

  def census_total(year)
    MemberCount.total_for_flock(year, self)
  end

  def census_details(year)
    MemberCount.details_for_flock(year, self)
  end

  def population_approveable?
    current_census = Census.current
    current_census && !MemberCounter.new(current_census.year, self).exists?
  end

  # Scharleitung
  class Leader < Jubla::Role::Leader
    self.permissions = [:layer_and_below_full, :contact_data, :approve_applications,
      :manual_deletion]
  end

  # Lagerleitung
  class CampLeader < ::Role
    self.permissions = [:layer_and_below_full, :contact_data]
    include Group::UniqueNextcloudGroup
  end

  # Präses
  class President < ::Role
    self.permissions = [:layer_and_below_read, :contact_data]
    include Group::UniqueNextcloudGroup

    self.used_attributes += [:employment_percent, :honorary]
  end

  # Leiter
  class Guide < ::Role
    self.permissions = [:layer_and_below_read]
    include Group::UniqueNextcloudGroup
  end

  # Kassier
  class Treasurer < Jubla::Role::Treasurer
    self.two_factor_authentication_enforced = true
    self.permissions = [:layer_and_below_read, :finance, :contact_data]
  end

  # Coach
  class Coach < ::Role
    self.permissions = [:layer_and_below_read]
    include Group::UniqueNextcloudGroup
    self.kind = nil
    self.visible_from_above = false
  end

  # Betreuer
  class Advisor < ::Role
    self.permissions = [:layer_and_below_read]
    include Group::UniqueNextcloudGroup
    self.kind = nil
    self.visible_from_above = false
  end

  class GroupAdmin < Jubla::Role::GroupAdmin
    self.permissions = [:layer_and_below_full]
  end

  class Alumnus < Jubla::Role::Alumnus
  end

  class External < Jubla::Role::External
  end

  class DispatchAddress < Jubla::Role::DispatchAddress
  end

  roles Leader,
    CampLeader,
    President,
    Treasurer,
    Guide,
    GroupAdmin,
    Alumnus,
    External,
    DispatchAddress

  restricted_role :coach, Coach
  restricted_role :advisor, Advisor
end
