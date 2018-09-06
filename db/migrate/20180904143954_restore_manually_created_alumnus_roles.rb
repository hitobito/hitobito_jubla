class RestoreManuallyCreatedAlumnusRoles < ActiveRecord::Migration
  include Rails.application.routes.url_helpers

  def down; end

  def up
    missing_roles = created_roles - deleted_roles - existing_alumnus_roles

    alumni_groups = select_rows(find_alumni_groups_sql)
    alumnus_group_memo = alumni_groups.index_by(&:first)

    group_layer_ids = select_rows(find_group_layer_ids_sql(missing_roles.map(&:first)))
    group_layer_ids_memo = group_layer_ids.index_by(&:first)

    new_alumnus_roles = map_alumnus_group(missing_roles, group_layer_ids_memo, alumnus_group_memo)

    execute(insert_roles_sql(new_alumnus_roles)) if new_alumnus_roles.present?
  end

  private

  def find_group_layer_ids_sql(group_ids)
    <<-SQL
    SELECT id, layer_group_id FROM groups
    WHERE id IN (#{sanitize(group_ids)})
    SQL
  end

  def find_alumni_groups_sql
    <<-SQL
    SELECT layer_group_id, id, type FROM groups
    WHERE groups.type like '%AlumnusGroup'
    SQL
  end

  def map_alumnus_group(list, layer_id_memo, alumnus_group_memo)
    list.collect do |group_id, person_id|
      _, layer_group_id = layer_id_memo.fetch(group_id)
      _, alumnus_id, type = alumnus_group_memo.fetch(layer_group_id) rescue next
      next if existing_alumnus_member.include?([alumnus_id, person_id])
      [alumnus_id, person_id, type]
    end.compact
  end

  def insert_roles_sql(new_alumnus_roles)
    now = Role.sanitize(Time.zone.now)
    <<-SQL
    INSERT INTO roles(created_at, updated_at, person_id, group_id, type)
    VALUES #{values(new_alumnus_roles, now).join(',')}
    SQL
  end

  def values(list, now)
    list.collect do |group_id, person_id, type|
      "(#{now}, #{now}, #{person_id}, #{group_id},"\
        " '#{type}::Member')"
    end
  end

  def existing_alumnus_member
    @existing_roles ||= Role.where("type like '%AlumnusGroup::Member'").pluck(:group_id, :person_id)
  end

  def existing_alumnus_roles
    Role.where("type like '%::Alumnus'").pluck(:group_id, :person_id)
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
    if type.match(/::Alumnus/)
      [group_id, person_id]
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
