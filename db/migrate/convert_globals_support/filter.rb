# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class FilterMigrator < RelationMigrator
  def current_relations
    PeopleFilter
      .joins(:related_role_types)
      .where(related_role_types: { role_type: role_type})
  end

  def handle(filter)
    { id: filter.id, role_types: role_types_for(filter.group) }
  end

  def build(attrs)
    role_types = attrs.fetch(:role_types)
    if role_types.present?
      filter = PeopleFilter.find(attrs.fetch(:id))
      role_types.each { |role_type| filter.related_role_types.build(role_type: role_type) }
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
