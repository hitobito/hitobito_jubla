# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Role
  extend ActiveSupport::Concern

  included do
    Role::Kinds << :alumnus

    attr_accessor :skip_alumnus_callback
    after_destroy :create_role_in_alumnus_group, unless: :skip_alumnus_callback

    validate :validate_alumnus_group
    after_create :destroy_alumnus_member_role
    after_save :set_person_origins
    after_destroy :set_person_origins
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

  def alumnus?
    self.class.alumnus?
  end

  private

  def validate_alumnus_group
    if group.is_a?(Group::AlumnusGroup) && !last_role_for_person_in_layer?
      errors.add(:base, I18n.t('activerecord.errors.messages.other_roles_exists'))
      return false
    end
  end

  def set_person_origins
    person.update_columns(GroupOriginator.new(person).to_h)
  end

  def create_role_in_alumnus_group
    if create_role?
      @group = group.alumni_groups.first
      return unless build_new_role.save
      AlumniMailJob.new(group.id, person.id).enqueue!(run_at: 1.day.from_now)
    end
  end

  def build_new_role
    new_role = Role.new
    new_role.person_id = person_id
    new_role.group_id = @group.id
    new_role.type = alumnus_role_type
    new_role
  end

  def alumnus_role_type
    "#{@group.type}::Member".constantize
  end

  def last_role_for_person_in_layer?
    group.groups_in_same_layer.collect do |g|
      g.roles.where(person_id: person_id)
    end.flatten.empty?
  end

  def create_role?
    self.class.member? &&
      old_enough_to_archive? &&
      last_role_for_person_in_layer? &&
      !group.is_a?(Group::AlumnusGroup) &&
      !is_a?(Group::ChildGroup::Child)
  end

  def destroy_alumnus_member_role
    return if alumnus? ||
      is_a?(Jubla::Role::External) ||
      is_a?(Jubla::Role::DispatchAddress) ||
      (is_a?(Jubla::Role::Member) && group.is_a?(Group::AlumnusGroup))

    person.roles.joins(:group).
      where(roles: { type: Group::AlumnusGroup::Member.subclasses.collect(&:sti_name)},
            groups: { layer_group_id: group.layer_group_id }).
    where.not(roles: { id: id }).destroy_all
  end

end
