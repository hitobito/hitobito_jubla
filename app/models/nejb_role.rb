# frozen_string_literal: true

#  Copyright (c) 2024-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class NejbRole < Role
  module AlumnusFreeRole
    def alumnus_manager
      @alumnus_manager ||= Jubla::Role::NullAlumnusManager.new
    end
  end
  include AlumnusFreeRole
end
