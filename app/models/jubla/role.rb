# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Role
  extend ActiveSupport::Concern

  included do
    Role::Kinds << :alumnus

    after_destroy :create_alumnus_role
  end

  module ClassMethods
    def alumnus?
      kind == :alumnus
    end
  end

  # Common roles not attached to a specific group

  # Adressverwaltung
  class GroupAdmin < ::Role
    self.permissions = [:group_full]
  end

  # Versandadresse. Intended to be used with mailing lists
  class DispatchAddress < ::Role
  end

  # Extern
  class External < ::Role
    self.permissions = []
    self.visible_from_above = false
    self.kind = :external
  end

  # Ehemalige
  class Alumnus < ::Role
    self.permissions = [:group_read]
    self.kind = :alumnus
  end

  # Common superclass for all J+S Coach roles
  class Coach < ::Role
    self.permissions = [:contact_data, :group_read]
  end

  # Common superclass for all leader roles
  # Primarly used for common naming
  class Leader < ::Role

  end

  # Common superclass for all member roles
  # Primarly used for common naming
  class Member < ::Role

  end

  # Common superclass for all traesurer roles
  class Treasurer < ::Role

  end

  private

  def create_alumnus_role
    if self.class.member? && old_enough_to_archive? && last_role_for_person_in_group?
      role = alumnus_class.new
      role.person = person
      role.group = group
      role.label = self.class.label
      role.save!
    end
  end

  def alumnus_class
    "#{group.class.to_s}::Alumnus".constantize
  end

  def last_role_for_person_in_group?
     group.roles.where(person_id: person_id).empty?
  end

end
