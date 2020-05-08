class RestoreManuallyCreatedAlumnusRoles < ActiveRecord::Migration[4.2]
  include Rails.application.routes.url_helpers

  def down; end

  def up
    missing_roles = created_roles - deleted_roles - existing_alumnus_roles

    execute(insert_roles_sql(missing_roles)) if missing_roles.present?
  end

  private

  def insert_roles_sql(new_alumnus_roles)
    now = Role.sanitize(Time.zone.now)

    <<-SQL.strip_heredoc
      INSERT INTO roles(created_at, updated_at, person_id, group_id, type)
      VALUES #{values(new_alumnus_roles, now).join(',')}
    SQL
  end

  def values(list, now)
    list.collect do |group_id, person_id, type|
      "(#{now}, #{now}, #{person_id}, #{group_id}, '#{type}')"
    end
  end

  def existing_alumnus_roles
    Role.where("type like '%::Alumnus'").pluck(:group_id, :person_id, :type)
  end

  def created_roles
    filter_role_versions(:create).map do |v|
      next unless v.changeset['type']
      format_role_version(v.changeset['group_id'][1], v.main_id, v.changeset['type'][1])
    end.compact
  end

  def deleted_roles
    filter_role_versions(:destroy).map do |v|
      v_object = YAML.load(v.object)
      format_role_version(v_object['group_id'], v_object['person_id'], v_object['type'])
    end.compact
  end

  def format_role_version(group_id, person_id, type)
    return unless type
    if type =~ /::Alumnus/
      [group_id, person_id, type]
    end
  end

  def filter_role_versions(event)
    PaperTrail::Version.where(main_type: Person.sti_name, event: event, item_type: 'Role').
                        reorder('created_at DESC, id DESC').
                        includes(:item)
  end

  def sanitize(list)
    list.collect { |item| ActiveRecord::Base.sanitize(item) }.join(',')
  end

end
