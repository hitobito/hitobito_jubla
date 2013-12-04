# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Ebene Bund
class Group::Federation < Group

  self.layer = true
  self.default_children = [Group::FederalBoard, Group::OrganizationBoard]
  self.contact_group_type = Group::FederalBoard
  self.event_types = [Event, Event::Course]

  children Group::FederalBoard,
           Group::OrganizationBoard,
           Group::FederalProfessionalGroup,
           Group::FederalWorkGroup,
           Group::State

  def census_total(year)
    MemberCount.total_for_federation(year)
  end

  def census_groups(year)
    MemberCount.total_by_states(year)
  end

  def census_details(year)
    MemberCount.details_for_federation(year)
  end

  class GroupAdmin < Jubla::Role::GroupAdmin
  end

  class Alumnus < Jubla::Role::Alumnus
  end

  class External < Jubla::Role::External
  end

  class DispatchAddress < Jubla::Role::DispatchAddress
  end

  roles GroupAdmin, Alumnus, External, DispatchAddress
end
