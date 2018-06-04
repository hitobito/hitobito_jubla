# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Role
  extend ActiveSupport::Concern

  included do
    Role::Kinds << :alumnus
    Role::Types::Permissions << :alumnus_below_full

    attr_accessor :skip_alumnus_callback
    after_destroy :create_role_in_alumnus_group, unless: :skip_alumnus_callback

    validate :assert_no_active_roles, if: :alumnus_group_member?
    after_create :destroy_alumnus_member_role, if: :alumnus_applicable?
    after_save :set_person_origins
    after_destroy :set_person_origins
  end

  module ClassMethods
    def alumnus?
      kind == :alumnus
    end

    def roles_in_layer(person_id, layer_group_id)
      Role.joins(:group).
        where(person: person_id,
              groups: { layer_group_id: layer_group_id })
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

  # Common superclass for all treasurer roles
  class Treasurer < ::Role
  end

  def alumnus?
    self.class.alumnus?
  end

  def alumnus_group_member?
    type.to_s.match(/AlumnusGroup::Member$/)
  end

  def alumnus_applicable?
    potential_alumnus? && !alumnus?
  end

  private

  def assert_no_active_roles
    if active_roles_in_layer.exists?
      errors.add(:base, I18n.t('activerecord.errors.messages.other_roles_exists'))
    end
  end

  def set_person_origins
    person.update_columns(GroupOriginator.new(person).to_h)
  end

  def create_role_in_alumnus_group
    if old_enough_to_archive? && potential_alumnus?
      Jubla::Role::AlumnusManager.new(self).create
    end
  end

  def roles_in_layer
    Role.roles_in_layer(person_id, group.layer_group.id)
  end

  def active_roles_in_layer
    roles_in_layer.where.not(roles: { type: alumnus_member_role_types })
  end

  def potential_alumnus?
    [Jubla::Role::External, Jubla::Role::DispatchAddress].none? { |r| is_a?(r) }
  end

  def destroy_alumnus_member_role
    Jubla::Role::AlumnusManager.new(self).destroy
  end

  def alumnus_member_role_types
    Group::AlumnusGroup::Member.subclasses.collect(&:sti_name)
  end

end
