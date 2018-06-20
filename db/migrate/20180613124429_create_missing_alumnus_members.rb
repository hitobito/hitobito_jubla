class CreateMissingAlumnusMembers < ActiveRecord::Migration
  include Rails.application.routes.url_helpers

  def down; end

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
    INNER JOIN groups ON roles.group_id = groups.id
    WHERE roles.type IN (#{sanitize(role_types)})
    AND roles.deleted_at IS NOT NULL
    AND person_id NOT IN (
      SELECT DISTINCT person_id FROM roles
      INNER JOIN groups g ON roles.group_id = g.id
      WHERE g.layer_group_id = groups.layer_group_id
      AND roles.deleted_at IS NULL
      AND (
        roles.type IN (#{sanitize(role_types)}) OR
        roles.type IN ('Group::FlockAlumnusGroup::Member', 'Group::ChildGroup::Child'))
    )
    AND layer_group_id NOT IN (
      SELECT DISTINCT id from groups
      WHERE deleted_at IS NOT NULL
    )
    GROUP BY person_id, layer_group_id
    SQL
  end

  def find_alumni_groups_sql(layer_group_ids)
    <<-SQL
    SELECT layer_group_id, id FROM groups
    WHERE layer_group_id IN (#{sanitize(layer_group_ids)})
    AND groups.type = 'Group::FlockAlumnusGroup'
    SQL
  end
  
  def insert_roles_sql(list, alumni_groups)
    now = Role.sanitize(Time.zone.now)
    <<-SQL
    INSERT INTO roles(created_at, updated_at, person_id, group_id, type)
    VALUES #{values(list, alumni_groups, now).join(',')}
    SQL
  end

  def values(list, alumnus_group_memo, now)
    list.collect do |person_id, layer_group_id|
      _, group_id = alumnus_group_memo.fetch(layer_group_id)
      "(#{now}, #{now}, #{person_id}, #{group_id},"\
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

  def sanitize(list)
    list.collect { |item| ActiveRecord::Base.sanitize(item) }.join(',')
  end

end
