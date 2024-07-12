# frozen_string_literal: true

#  Copyright (c) 2012-2022, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Event::Camp::Role
  class Coach < ::Event::Role
    self.permissions = [:participations_full, :contact_data]

    self.kind = nil
  end
end
