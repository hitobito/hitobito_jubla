# frozen_string_literal: true

#  Copyright (c) 2024-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Group::NejbBundesleitung < ::Group
  class GroupAdmin < ::NejbRole
    self.permissions = [:admin, :layer_and_below_full, :contact_data]
  end

  roles GroupAdmin
end
