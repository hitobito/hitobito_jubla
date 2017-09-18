# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::Group::Merger
  extend ActiveSupport::Concern

  included do
    alias_method_chain :copy_roles, :role_deletion
  end

  def copy_roles_with_role_deletion
    roles = group1.roles + group2.roles
    roles.each do |role|
      new_role = role.dup
      new_role.group_id = new_group.id
      new_role.save!
      role.skip_alumnus_callback = true
      role.destroy
    end
    @group1.reload
    @group2.reload
  end
end
