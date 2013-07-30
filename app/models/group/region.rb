# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Ebene Region
class Group::Region < Group
  
  self.layer = true
  self.default_children = [Group::RegionalBoard]
  
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
  
  children Group::RegionalBoard,
           Group::RegionalProfessionalGroup,
           Group::RegionalWorkGroup,
           Group::Flock
           
  attr_accessible *(accessible_attributes.to_a + [:jubla_insurance, :jubla_full_coverage]), :as => :superior

end
