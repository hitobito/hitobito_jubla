class CreateAlumniRolesInAlumniGroups < ActiveRecord::Migration[4.2]
  def up
    alumni = select_rows(find_people_sql)
    return unless alumni.present?

    alumni_groups = select_rows(find_groups_sql(alumni.collect(&:second).uniq))

    execute(insert_roles_sql(alumni, alumni_groups.index_by(&:first)))
  end

  def down
    execute(delete_alumni_group_members_sql)
  end

  private

  def delete_alumni_group_members_sql
    <<-SQL
    DELETE FROM roles
    WHERE type IN (#{quote(alumni_member_types)})
    SQL
  end

  def find_people_sql
    role_types = existing_alumni_role_types - ["Group::ChildGroup::Alumnus"]
    <<-SQL
    SELECT DISTINCT person_id, layer_group_id FROM roles
    INNER JOIN #{table("groups")} ON roles.group_id = #{table("groups")}.id
    WHERE roles.type IN (#{quote(role_types)})
    AND (roles.end_on IS NULL OR roles.end_on > CURRENT_DATE)
    AND person_id NOT IN (
      SELECT DISTINCT person_id FROM roles
      INNER JOIN #{table("groups")} g ON roles.group_id = g.id
      WHERE g.layer_group_id = layer_group_id
      AND (roles.end_on IS NULL OR roles.end_on > CURRENT_DATE)
      AND (roles.type NOT IN (#{quote(role_types)}) OR
          roles.type IN (#{quote(external_role_types)}))
    )
    GROUP BY person_id, layer_group_id
    SQL
  end

  def find_groups_sql(layer_group_ids)
    <<-SQL
    SELECT layer_group_id, id, type FROM #{table("groups")}
    WHERE layer_group_id IN (#{quote(layer_group_ids)})
    AND #{table("groups")}.type IN (#{quote(new_alumni_group_types)})
    SQL
  end

  def insert_roles_sql(list, group_memo, now = Role.quote(Time.zone.now))
    <<-SQL
    INSERT INTO roles(created_at, updated_at, person_id, group_id, type)
    VALUES #{values(list, group_memo, now).join(",")}
    SQL
  end

  def values(list, group_memo, now)
    list.collect do |person_id, layer_group_id, _|
      _, group_id, group_type = group_memo.fetch(layer_group_id)
      type = Role.quote(member(group_type))
      "(#{now}, #{now}, #{person_id}, #{group_id}, #{type})"
    end
  end

  def alumni_member_types
    new_alumni_group_types.collect { |group_type| member(group_type) }
  end

  def member(group_type)
    [group_type, "Member"].join("::").constantize.to_s
  end

  def quote(list)
    list.collect { |item| ActiveRecord::Base.connection.quote(item) }.join(",")
  end

  def table(name)
    ActiveRecord::Base.connection.quote_table_name(name)
  end

  def new_alumni_group_types
    ["Group::AlumnusGroup",
      "Group::StateAlumnusGroup",
      "Group::FederalAlumnusGroup",
      "Group::FlockAlumnusGroup",
      "Group::RegionalAlumnusGroup"]
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

  def external_role_types
    ["Group::AlumnusGroup::External",
      "Group::SimpleGroup::External",
      "Group::FederalBoard::External",
      "Group::OrganizationBoard::External",
      "Group::FederalProfessionalGroup::External",
      "Group::FederalWorkGroup::External",
      "Group::StateAgency::External",
      "Group::StateBoard::External",
      "Group::State::External",
      "Group::StateProfessionalGroup::External",
      "Group::StateWorkGroup::External",
      "Group::RegionalBoard::External",
      "Group::Region::External",
      "Group::RegionalProfessionalGroup::External",
      "Group::RegionalWorkGroup::External",
      "Group::ChildGroup::External",
      "Group::Flock::External",
      "Group::Federation::External"]
  end
end
