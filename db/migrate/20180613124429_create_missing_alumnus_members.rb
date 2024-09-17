class CreateMissingAlumnusMembers < ActiveRecord::Migration[4.2]
  include Rails.application.routes.url_helpers

  def down
  end

  def up
    missing_alumni = select_rows(find_missing_people_sql)
    return if missing_alumni.blank?
    alumni_groups = select_rows(find_alumni_groups_sql(missing_alumni.collect(&:second).uniq))

    execute(insert_roles_sql(missing_alumni, alumni_groups.index_by(&:first)))
  end

  private

  def find_missing_people_sql
    <<-SQL
    SELECT DISTINCT person_id, layer_group_id FROM roles
    INNER JOIN #{table("groups")} ON roles.group_id = #{table("groups")}.id
    WHERE roles.type IN (#{quote(role_types)})
    AND (roles.end_on IS NULL OR roles.end_on > CURRENT_DATE)
    AND person_id NOT IN (
      SELECT DISTINCT person_id FROM roles
      INNER JOIN #{table("groups")} g ON roles.group_id = g.id
      WHERE g.layer_group_id = #{table("groups")}.layer_group_id
      AND (roles.end_on IS NULL OR roles.end_on > CURRENT_DATE)
      AND (
        roles.type IN (#{quote(role_types)}) OR
        roles.type IN ('Group::FlockAlumnusGroup::Member', 'Group::ChildGroup::Child'))
    )
    AND layer_group_id NOT IN (
      SELECT DISTINCT id from #{table("groups")}
      WHERE deleted_at IS NOT NULL
    )
    GROUP BY person_id, layer_group_id
    SQL
  end

  def find_alumni_groups_sql(layer_group_ids)
    <<-SQL
    SELECT layer_group_id, id FROM #{table("groups")}
    WHERE layer_group_id IN (#{quote(layer_group_ids)})
    AND #{table("groups")}.type = 'Group::FlockAlumnusGroup'
    SQL
  end

  def insert_roles_sql(list, alumni_groups)
    now = Role.quote(Time.zone.now)
    <<-SQL
    INSERT INTO roles(created_at, updated_at, person_id, group_id, type)
    VALUES #{values(list, alumni_groups, now).join(",")}
    SQL
  end

  def values(list, alumnus_group_memo, now)
    list.collect do |person_id, layer_group_id|
      _, group_id = alumnus_group_memo.fetch(layer_group_id)
      "(#{now}, #{now}, #{person_id}, #{group_id}," \
        " 'Group::FlockAlumnusGroup::Member')"
    end
  end

  def role_types
    ["Group::Flock::President",
      "Group::Flock::Guide",
      "Group::Flock::Leader",
      "Group::Flock::Treasurer",
      "Group::Flock::GroupAdmin",
      "Group::Flock::DispatchAddress",
      "Group::Flock::CampLeader",
      "Group::Flock::Advisor",
      "Group::ChildGroup::Leader",
      "Group::ChildGroup::GroupAdmin",
      "Group::ChildGroup::DispatchAddress"]
  end

  def quote(list)
    list.collect { |item| ActiveRecord::Base.connection.quote(item) }.join(",")
  end

  def table(name)
    ActiveRecord::Base.connection.quote_table_name(name)
  end
end
