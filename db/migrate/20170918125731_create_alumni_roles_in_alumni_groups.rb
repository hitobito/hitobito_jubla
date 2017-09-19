class CreateAlumniRolesInAlumniGroups < ActiveRecord::Migration

  def up
    alumni = select_rows(find_peple_sql)
    alumni_groups = select_rows(find_groups_sql(alumni))
    execute(insert_roles_sql(alumni, alumni_groups.index_by(&:first)))
  end

  def down
    execute(delete_alumni_group_members_sql)
  end

  private

  def delete_alumni_group_members_sql
    <<-SQL
    DELETE FROM roles
    WHERE roles.id IN (
      SELECT roles.id FROM roles
      INNER JOIN groups ON roles.group_id = groups.id
      WHERE groups.type IN (#{sanitize(new_alumni_group_types)})
      AND roles.type IN (#{sanitize(alumni_member_types)})
    )
    SQL
  end

  def find_peple_sql
    <<-SQL
    SELECT person_id, group_id FROM roles
    WHERE type IN (#{sanitize(existing_alumni_role_types)})
    AND person_id NOT IN (
      SELECT DISTINCT person_id FROM roles
      WHERE type NOT IN (#{sanitize(existing_alumni_role_types)})
    )
    GROUP BY person_id, group_id
    SQL
  end

  def find_groups_sql(list)
    <<-SQL
    SELECT groups.id, g1.id, g1.type FROM groups
    INNER JOIN groups AS g1 ON g1.layer_group_id = groups.layer_group_id
    WHERE groups.id IN (#{sanitize(list.collect(&:second))})
    AND g1.type IN (#{sanitize(new_alumni_group_types)})
    SQL
  end

  def insert_roles_sql(list, group_memo, now = Role.sanitize(Time.zone.now))
    <<-SQL
    INSERT INTO roles(created_at, updated_at, person_id, group_id, type)
    VALUES #{values(list, group_memo, now).join(',')}
    SQL
  end

  def values(list, group_memo, now)
    list.collect do |person_id, group_id|
      _, group_id, group_type = group_memo.fetch(group_id)
      type = Role.sanitize(member(group_type))
      "(#{now}, #{now}, #{person_id}, #{group_id}, #{type})"
    end
  end

  def alumni_member_types
    new_alumni_group_types.collect { |group_type| member(group_type) }
  end

  def member(group_type)
    [ group_type, "Member" ].join("::").constantize.to_s
  end

  def sanitize(list)
    list.collect { |item| ActiveRecord::Base.sanitize(item) }.join(',')
  end


  def new_alumni_group_types
    ["Group::AlumnusGroup",
     "Group::StateAlumnusGroup",
     "Group::FederalAlumnusGroup",
     "Group::FlockAlumnusGroup",
     "Group::RegionalAlumnusGroup"
    ]
  end

  def existing_alumni_role_types
    ["Group::SimpleGroup::Alumnus",
     "Group::FederalBoard::Alumnus",
     "Group::OrganizationBoard::Alumnus",
     "Group::FederalProfessionalGroup::Alumnus",
     "Group::FederalWorkGroup::Alumnus",
     "Group::StateAgency::Alumnus",
     "Group::StateBoard::Alumnus",
     "Group::State::Alumnus",
     "Group::StateProfessionalGroup::Alumnus",
     "Group::StateWorkGroup::Alumnus",
     "Group::RegionalBoard::Alumnus",
     "Group::Region::Alumnus",
     "Group::RegionalProfessionalGroup::Alumnus",
     "Group::RegionalWorkGroup::Alumnus",
     "Group::ChildGroup::Alumnus",
     "Group::Flock::Alumnus",
     "Group::Federation::Alumnus"]
  end
end
