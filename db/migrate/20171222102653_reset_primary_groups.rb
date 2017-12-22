# encoding: utf-8

#  Copyright (c) 2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class ResetPrimaryGroups < ActiveRecord::Migration
  def up
    people_ids = select_all(people_with_wrong_assigned_primary_group).rows.join(',')
    execute(set_primary_group_to_active_role_group(people_ids))
    
    reloaded_people_ids = select_all(people_with_wrong_assigned_primary_group).rows.join(',')
    execute(set_primary_group_to_alumnus_role_group(reloaded_people_ids))
  end

  private
  
  def set_primary_group_to_active_role_group(people_ids)
    sql = <<-SQL
    UPDATE people 
    SET primary_group_id = (
      SELECT group_id from roles
      WHERE roles.person_id = people.id
      AND roles.type not in (#{alumni_role_types})
      AND roles.deleted_at is NULL
      LIMIT 1
    ) 
    SQL
    sql << "WHERE id NOT IN (#{people_ids})" if people_ids.present?
    sql
  end

  def set_primary_group_to_alumnus_role_group(people_ids)
    sql = <<-SQL
    UPDATE people 
    SET primary_group_id = (
      SELECT group_id from roles
      WHERE roles.person_id = people.id
      AND roles.deleted_at is NULL
      LIMIT 1
    ) 
    SQL
    sql << "WHERE id NOT IN (#{people_ids})" if people_ids.present?
    sql
  end

  def people_with_wrong_assigned_primary_group
    <<-SQL
    SELECT DISTINCT people.id from people
    LEFT JOIN roles ON roles.person_id = people.id 
    WHERE roles.group_id = people.primary_group_id
    AND roles.deleted_at IS NULL
    SQL
  end

  def alumni_role_types
    Group::AlumnusGroup.subclasses.
      flat_map(&:roles).
      collect(&:sti_name).
      collect { |x| "'#{x}'" }.join(",")
  end
end
