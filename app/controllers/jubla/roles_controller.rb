#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::RolesController
  extend ActiveSupport::Concern

  included do
    alias_method_chain :create_new_role_and_destroy_old_role, :alumni
  end

  def create_new_role_and_destroy_old_role_with_alumni
    @new_role = build_new_type
    authorize!(:create, @new_role)

    Role.transaction do
      entry.skip_alumnus_callback = true
      entry.destroy
      raise ActiveRecord::Rollback unless @new_role.valid?
      @new_role.save!
    end
  end
end
