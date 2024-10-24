# frozen_string_literal: true

#  Copyright (c) 2024-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Group::Nejb < ::Group
  self.layer = true
  children Group::NejbBundesleitung,
    Group::NetzwerkEhemaligeJungwachtBlauring,
    Group::NejbKanton

  ### ROLES

  class GroupAdmin < ::Role
    self.permissions = [:group_full]
  end

  class DispatchAddress < ::Role
    self.permissions = []
  end

  class ITSupport < ::Role
    self.permissions = [:admin, :impersonation]
  end

  roles GroupAdmin, DispatchAddress, ITSupport
end
