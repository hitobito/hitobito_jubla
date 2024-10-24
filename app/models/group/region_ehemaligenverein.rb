# frozen_string_literal: true

#  Copyright (c) 2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Group::RegionEhemaligenverein < ::Group
  ### ROLES

  class Leader < ::Role
    self.permissions = [:group_and_below_full, :contact_data]
  end

  class GroupAdmin < ::Role
    self.permissions = [:group_and_below_full]
  end

  class Treasurer < ::Role
    self.permissions = [:group_and_below_read]
  end

  class NejbMember < ::Role
    self.permissions = [:group_read]
  end

  class NejbJoiner < ::Role
    self.permissions = []
  end

  class External < ::Role
    self.permissions = []
  end

  class DispatchAddress < ::Role
    self.permissions = []
  end

  roles Leader, GroupAdmin, Treasurer, NejbMember, NejbJoiner, External, DispatchAddress
end
