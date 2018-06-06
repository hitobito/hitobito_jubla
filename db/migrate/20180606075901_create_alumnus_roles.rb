class CreateAlumnusRoles < ActiveRecord::Migration
  def up
    rows = select_rows(find_missing_roles_statement)
    rows.each do |person_id, group_id, group_type, role_type|
      label = role_type.constantize.model_name.human rescue ""
      execute(insert_role_statement(person_id, group_id, group_type, label))
    end
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

  def insert_role_statement(person_id, group_id, group_type, label)
    <<-SQL
    INSERT INTO roles(person_id, group_id, type, label)
    VALUES(#{person_id}, #{group_id}, "#{group_type}::Alumnus", "#{label}")
    SQL
  end

  def find_missing_roles_statement
    <<-SQL
      SELECT person_id, group_id, groups.type, roles.type FROM roles
      INNER JOIN groups ON roles.group_id = groups.id
      WHERE roles.deleted_at IS NOT NULL AND person_id NOT IN (
        SELECT person_id FROM roles
        WHERE roles.person_id = person_id AND roles.group_id = group_id AND roles.deleted_at is null
      ) GROUP BY group_id, person_id
    SQL
  end

end
