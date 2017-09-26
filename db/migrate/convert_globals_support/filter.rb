# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class FilterMigrator < RelationMigrator
  def current_relations
    PeopleFilter
      .joins(<<-SQL.strip_heredoc).where('`related_role_types`.`role_type` = ?', role_type)
        INNER JOIN `related_role_types`
          ON (`related_role_types`.`relation_id` = `people_filters`.`id`
          AND `related_role_types`.`relation_type` = 'PeopleFilter')
      SQL
  end

  def handle(filter)
    { id: filter.id, role_types: role_types_for(filter.group) }
  end

  def build(attrs)
    role_types = attrs.fetch(:role_types)
    if role_types.present?
      filter = PeopleFilter.find(attrs.fetch(:id))
      role_types.each { |role_type| RelatedRoleType.new(role_type: role_type, relation: filter) }
      filter
    end
  end
end

class AlumnusFilterMigrator < FilterMigrator
  def initialize
    super(Jubla::Role::Alumnus)
  end
end

class DispatchAddressFilterMigrator < FilterMigrator
  def initialize
    super(Jubla::Role::DispatchAddress)
  end
end
