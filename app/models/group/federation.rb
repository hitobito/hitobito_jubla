# frozen_string_literal: true

#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
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

# Ebene Bund
class Group::Federation < Group
  self.layer = true
  self.default_children = [Group::FederalBoard, Group::OrganizationBoard,
    Group::FederalAlumnusGroup]
  self.contact_group_type = Group::FederalBoard
  self.event_types = [Event, Event::Course]

  children Group::FederalBoard,
    Group::OrganizationBoard,
    Group::FederalProfessionalGroup,
    Group::FederalWorkGroup,
    Group::State,
    Group::FederalAlumnusGroup

  def census_total(year)
    MemberCount.total_for_federation(year)
  end

  def census_groups(year)
    MemberCount.total_by_states(year)
  end

  def census_details(year)
    MemberCount.details_for_federation(year)
  end

  def member_counts
    MemberCount.all
  end

  class GroupAdmin < Jubla::Role::GroupAdmin
  end

  class Alumnus < Jubla::Role::Alumnus
  end

  class External < Jubla::Role::External
  end

  class DispatchAddress < Jubla::Role::DispatchAddress
  end

  class ItSupport < Jubla::Role::Member
    self.permissions = [:impersonation]
  end

  roles GroupAdmin, Alumnus, External, DispatchAddress, ItSupport
end
