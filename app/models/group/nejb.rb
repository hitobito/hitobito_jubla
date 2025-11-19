# frozen_string_literal: true

#  Copyright (c) 2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Group::Nejb < NejbGroup
  self.layer = true
  children Group::NejbBundesleitung,
    Group::NetzwerkEhemaligeJungwachtBlauring,
    Group::NejbKanton

  ### ROLES

  class GroupAdmin < ::NejbRole
    self.permissions = [:group_full]
  end

  class DispatchAddress < ::NejbRole
    self.permissions = []
  end

  class ITSupport < ::NejbRole
    self.two_factor_authentication_enforced = true
    self.permissions = [:admin, :impersonation]
  end

  roles GroupAdmin, DispatchAddress, ITSupport
end
