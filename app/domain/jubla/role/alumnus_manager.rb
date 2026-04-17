# frozen_string_literal: true

#  Copyright (c) 2021-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Role
  class AlumnusManager
    attr_reader :role, :group, :person

    def initialize(role, skip_alumnus_callback: false)
      @role = role
      @group = role.group
      @person = role.person
      @skip_alumnus_callback = skip_alumnus_callback
    end

    def after_role_create
      if role.alumnus_member?
        if roles_in_layer.alumnus_members.one?
          # The current role that has just been created is the only alumnus_member role in the layer
          # This should not be called in this case:
          # create_alumnus_role if last_in_group? => circular? we just created an alumnus_role
          return if skip_alumnus_callback?
          create_alumnus_group_member if last_in_layer? && person_old_enough?
        end
      else
        if !group.alumnus?
          # The current role that has just been created is a non-alumni role in a not-alumni group
          destroy_alumnus_role
          destroy_alumnus_group_member
        end
      end
    end

    def after_role_destroy
      if role.alumnus_member?
        if roles_in_layer.alumnus_members.blank?
          # The current role that has just been destroyed was the last alumnus_member role in the layer
          # This should not be called in this case:
          # destroy_alumnus_role => does nothing, it was already the last role
          # destroy_alumnus_group_member => the memberships should be kept
        end
      else
        if role.old_enough_to_soft_destroy? && role.alumnus_applicable?
          # The current role that has just been destroyed was the last non-alumnus role in this group
          create_alumnus_role if last_in_group?
          return if skip_alumnus_callback?
          create_alumnus_group_member if last_in_layer? && person_old_enough?
        end
      end
    end

    def create
      create_alumnus_role if last_in_group?

      return if skip_alumnus_callback?

      create_alumnus_group_member if last_in_layer? && person_old_enough?
    end

    def destroy
      destroy_alumnus_role
      destroy_alumnus_group_member
    end

    private

    def roles_in_layer
      Role.roles_in_layer(person.id, group.layer_group.id)
    end

    def create_alumnus_role
      return unless group.alumnus_class
      alumnus_role = group.alumnus_class.new(person: person, group: group)
      alumnus_role.label = role.class.label
      alumnus_role.save!
    end

    def create_alumnus_group_member
      return if alumnus_group.blank?
      return if alumnus_group_member_exists?

      member = group.alumnus_member_class.new(person: person, group: alumnus_group)

      enqueue_mail_job if member.save && person.email.present?
    end

    def alumnus_group_member_exists?
      Role.where("type like '%::Member'")
        .where(person: person, group: alumnus_group)
        .present?
    end

    def destroy_alumnus_role
      person
        .roles
        .joins(:group)
        .where(group: group, type: group.alumnus_class.sti_name)
        .destroy_all
    end

    def destroy_alumnus_group_member
      alumnus_member_roles_in_layer.where.not(roles: {id: role.id}).destroy_all
    end

    def skip_alumnus_callback?
      @skip_alumnus_callback
    end

    def person_old_enough?
      return true unless group.is_a?(Group::ChildGroup)
      return false unless person.years

      min_age_for_alumni_member <= person.years
    end

    def min_age_for_alumni_member
      @min_age_for_alumni_member ||=
        Settings.alumni_administrations.min_age_for_alumni_member
    end

    def enqueue_mail_job
      AlumniMailJob.new(alumnus_group.id, role.person.id).enqueue!(run_at: 1.day.from_now)
    end

    def alumnus_member_roles_in_layer
      role.roles_in_layer.where("roles.type ~ ?", "AlumnusGroup::Member")
    end

    def last_in_group?
      group.roles.where(person_id: person.id).empty?
    end

    def last_in_layer?
      role.active_roles_in_layer.empty?
    end

    def alumnus_group
      group.alumnus_group
    end
  end
end
