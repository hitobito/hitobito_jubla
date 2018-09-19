module Jubla::Role
  class AlumnusManager

    attr_reader :role, :group, :person

    def initialize(role, skip_alumnus_callback = false)
      @role = role
      @group = role.group
      @person = role.person
      @skip_alumnus_callback = skip_alumnus_callback
    end

    def create
      create_alumnus_role if last_in_group?

      if last_in_layer? && person_old_enough?
        create_alumnus_group_member unless skip_alumnus_callback?
      end
    end

    def destroy
      destroy_alumnus_role
      destroy_alumnus_group_member
    end

    private

    def create_alumnus_role
      alumnus_role = group.alumnus_class.new(person: person, group: group)
      alumnus_role.label = role.class.label
      alumnus_role.save!
    end

    def create_alumnus_group_member
      return if alumnus_group_member_exists?

      member = group.alumnus_member_class.new(person: person, group: alumnus_group)

      if member.save
        enqueue_mail_job if person.email.present?
      end
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
        .where(group: group, type: group.alumnus_class)
        .destroy_all
    end

    def destroy_alumnus_group_member
      alumnus_member_roles_in_layer.where.not(roles: { id: role.id }).destroy_all
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
      role.roles_in_layer.
        where('roles.type REGEXP "AlumnusGroup::Member"')
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
