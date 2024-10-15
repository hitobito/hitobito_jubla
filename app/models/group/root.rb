# frozen_string_literal: true

#  Copyright (c) 2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Group::Root < ::Group
  self.layer = true
  self.event_types = []

  class NullAlumnusManager
    def create = true

    def destroy = true
  end

  class Admin < ::Role
    self.permissions = [:layer_and_below_full, :admin]
    self.two_factor_authentication_enforced = true

    def skip_alumnus_callbacks
      true
    end

    def alumnus_manager
      @alumnus_manager ||= NullAlumnusManager.new
    end
  end

  roles Admin

  children Group::Federation
end
