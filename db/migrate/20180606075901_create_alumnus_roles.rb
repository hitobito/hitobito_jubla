class CreateAlumnusRoles < ActiveRecord::Migration
  def up
    deleted_role_rows = select_rows(find_missing_roles_statement)

    execute(insert_roles_statement(most_recent_deleted_role_rows(deleted_role_rows)))
    execute delete_filter_statement
  end

  def down
    execute delete_roles_statement

    Group.find_each do |group|
      next if group.alumnus?
      group.create_alumni_filter
    end
  end

  private

  def delete_filter_statement
    <<-SQL
    DELETE from people_filters
    WHERE name = 'Ehemalige'
    SQL
  end

  def delete_roles_statement
    <<-SQL
    DELETE from roles
    WHERE type LIKE "%::Alumnus"
    SQL
  end

  def insert_roles_statement(rows)
    <<-SQL
    INSERT INTO roles(person_id, group_id, type, label, created_at, updated_at)
    VALUES #{values(rows).join(',')}
    SQL
  end

  def values(rows)
    rows.collect do |person_id, group_id, group_type, role_type, deleted_at|
      sanitized_time = Role.sanitize(deleted_at)
      label = "'#{role_type.constantize.model_name.human}'" rescue nil
      "(#{person_id}, #{group_id}, '#{group_type}::Alumnus',"\
        " #{label}, #{sanitized_time}, #{sanitized_time})"
    end
  end

  def find_missing_roles_statement
    <<-SQL
      SELECT roles.person_id, roles.group_id, groups.type, roles.type, roles.deleted_at FROM roles
      INNER JOIN groups ON roles.group_id = groups.id
      WHERE roles.deleted_at IS NOT NULL
      AND roles.type NOT LIKE '%::External' AND roles.type NOT LIKE '%::DispatchAddress'
      AND roles.person_id NOT IN (
        SELECT person_id FROM roles r1
        WHERE r1.person_id = roles.person_id AND r1.group_id = roles.group_id AND r1.deleted_at is null
      )
      ORDER BY deleted_at DESC
    SQL
  end

  def most_recent_deleted_role_rows(rows)
    rows.group_by do |person_id, group_id|
      [person_id, group_id]
    end.values.collect(&:first)
  end

end
