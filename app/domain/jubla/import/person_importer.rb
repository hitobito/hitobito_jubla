#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::Import::PersonImporter
  extend ActiveSupport::Concern

  included do
    alias_method_chain :valid?, :alumnus
    alias_method_chain :count_person, :alumnus
  end

  def valid_with_alumnus?(import_person)
    check_for_alumnus_errors(import_person)
    valid_without_alumnus?(import_person)
  end

  def count_person_with_alumnus(import_person, index)
    count_person_without_alumnus(import_person, index)

    if @has_alumnus_error
      @errors << I18n.t("activerecord.errors.messages.cannot_import_alumnus",
        name: import_person.person.full_name)
    end
  end

  private

  def check_for_alumnus_errors(import_person)
    return unless alumnus_member_role?
    roles_in_layer = Role.roles_in_layer(import_person.person.id, group.layer_group.id)
    @has_alumnus_error = roles_in_layer.exists?
  end

  def alumnus_member_role?
    role_type.to_s.match(/AlumnusGroup::Member$/)
  end
end
