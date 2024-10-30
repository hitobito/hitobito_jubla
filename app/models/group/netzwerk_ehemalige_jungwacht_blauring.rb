# frozen_string_literal: true

#  Copyright (c) 2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Group::NetzwerkEhemaligeJungwachtBlauring < NejbGroup
  ### ROLES

  class Leader < ::NejbRole
    self.permissions = [:group_and_below_full, :contact_data]
  end

  class GroupAdmin < ::NejbRole
    self.permissions = [:group_and_below_full]
  end

  class Treasurer < ::NejbRole
    self.permissions = [:group_and_below_read]
  end

  class ActiveMember < ::NejbRole
    self.permissions = [:group_read]
  end

  class PassiveMember < ::NejbRole
    self.permissions = [:group_read]
  end

  class CollectiveMember < ::NejbRole
    self.permissions = [:group_read]
  end

  class NejbJoiner < ::NejbRole
    self.permissions = []
  end

  class External < ::NejbRole
    self.permissions = []
  end

  class DispatchAddress < ::NejbRole
    self.permissions = []
  end

  roles Leader, GroupAdmin, Treasurer, ActiveMember, PassiveMember, CollectiveMember, NejbJoiner, External, DispatchAddress
end
