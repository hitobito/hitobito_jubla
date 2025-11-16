# frozen_string_literal: true

#  Copyright (c) 2012-2025, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Role
  extend ActiveSupport::Concern

  included do
    Role::Kinds << :alumnus
    Role::Types::Permissions << :alumnus_below_full

    attr_accessor :skip_alumnus_callback

    validate :assert_no_active_roles, if: :alumnus_group_member?

    after_save :set_person_origins
    after_destroy :set_person_origins

    after_create :alumnus_manager_destroy
    after_destroy :alumnus_manager_create

    after_create :alumnus_manager_create_for_alumnus, if: :alumnus_member?
    after_destroy :alumnus_manager_destroy_for_alumnus, if: :alumnus_member?
  end

  module ClassMethods
    def alumnus
      where("roles.type ~ ?", "AlumnusGroup::Member|::Alumnus")
    end

    def alumnus_members
      where("roles.type LIKE '%::Alumnus'")
    end

    def without_alumnus
      where.not("roles.type ~ ?", "AlumnusGroup::Member|::Alumnus")
    end

    def without_alumnus_members
      where.not("roles.type LIKE '%::Alumnus'")
    end

    def roles_in_layer(person_id, layer_group_id)
      Role.joins(:group)
        .where(person: person_id,
          groups: {layer_group_id: layer_group_id})
    end
  end

  # Common roles not attached to a specific group

  # Adressverwaltung
  class GroupAdmin < ::Role
    self.permissions = [:group_full]
    include Group::UniqueNextcloudGroup
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
    include Group::UniqueNextcloudGroup
  end

  # Common superclass for all leader roles
  # Primarly used for common naming
  class Leader < ::Role
    include Group::UniqueNextcloudGroup
  end

  # Common superclass for all member roles
  # Primarly used for common naming
  class Member < ::Role
    include Group::UniqueNextcloudGroup
  end

  # Common superclass for all treasurer roles
  class Treasurer < ::Role
    include Group::UniqueNextcloudGroup
  end

  def alumnus_group_member?
    type.to_s.match(/AlumnusGroup::Member$/) && !(end_on&.past?)
  end

  def alumnus_member?
    kind == :alumnus
  end

  def alumnus_applicable?
    !group.alumnus? && Alumni::EXCLUDED_ROLE_TYPES.none? { |type| is_a?(type) }
  end

  def roles_in_layer
    Role.roles_in_layer(person_id, group.layer_group.id)
  end

  def active_roles_in_layer
    roles_in_layer.without_alumnus
  end

  private

  def assert_no_active_roles
    if active_roles_in_layer.exists?
      errors.add(:base, I18n.t("activerecord.errors.messages.other_roles_exists"))
    end
  end

  def set_person_origins
    person.update_columns(GroupOriginator.new(person).to_h) # rubocop:disable Rails/SkipsModelValidations intentionally, because it's called from an after_save hook
  end

  def alumnus_manager_create
    alumnus_manager.create if old_enough_to_soft_destroy? && alumnus_applicable?
  end

  def alumnus_manager_destroy
    alumnus_manager.destroy unless group.alumnus? || alumnus_member?
  end

  def alumnus_manager_create_for_alumnus
    alumnus_manager.create if roles_in_layer.alumnus_members.one?
  end

  def alumnus_manager_destroy_for_alumnus
    alumnus_manager.destroy if roles_in_layer.alumnus_members.blank?
  end

  def alumnus_manager
    @alumnus_manager ||= if %w[Flock ChildGroup FlockAlumnusGroup].include? type.split("::", 3)[1]
      Jubla::Role::AlumnusManager.new(self, skip_alumnus_callback: skip_alumnus_callback)
    else
      Jubla::Role::LightAlumnusManager.new(self)
    end
  end
end
