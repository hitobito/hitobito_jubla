# frozen_string_literal: true

#  Copyright (c) 2021-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# Trimmed down version of the Jubla::Role::AlumnusManager
#
# This one only creates the "exiting"-role that can be filtered. It does not add
# the person to the "former people"-group
module Jubla::Role
  class LightAlumnusManager
    attr_reader :role, :group, :person

    def initialize(role)
      @role = role
      @group = role.group
      @person = role.person
    end

    def create
      create_alumnus_role if last_in_group?
    end

    def destroy
      destroy_alumnus_role
    end

    private

    def create_alumnus_role
      alumnus_role = group.alumnus_class.new(person: person, group: group)
      alumnus_role.label = role.class.label
      alumnus_role.save!
    end

    def destroy_alumnus_role
      person
        .roles
        .joins(:group)
        .where(group: group, type: group.alumnus_class.name)
        .destroy_all
    end

    def last_in_group?
      group.roles.where(person_id: person.id).empty?
    end
  end
end
