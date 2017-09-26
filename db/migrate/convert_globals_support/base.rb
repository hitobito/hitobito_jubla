# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class RelationMigrator
  attr_reader :new_relations, :role_type, :role_type_name

  def initialize(role_type)
    @role_type = role_type
    @role_type_name = role_type.to_s.demodulize
  end

  def perform
    current_relations.each do |relation|
      specific_role_types(relation).each do |specific_role_type|
        RelatedRoleType.create(role_type: specific_role_type, relation: relation)
      end
      RelatedRoleType.where(role_type: role_type, relation: relation).destroy_all
    end
  end

  def current_relations
    @current_relations ||= relation_class
      .joins(<<-SQL.strip_heredoc).where('`related_role_types`.`role_type` = ?', role_type)
        INNER JOIN `related_role_types`
          ON (`related_role_types`.`relation_id` = `#{relation_class.name.tableize}`.`id`
          AND `related_role_types`.`relation_type` = '#{relation_class.name}')
      SQL
  end

  private

  def specific_role_types(relation)
    group = group_for(relation)
    role_types_for(group.class.child_types)
  end

  def role_types_for(groups)
    groups.map do |child_group_class|
      child_group_class.const_defined?(:"#{role_type_name}") ? "#{child_group_class}::#{role_type_name}" : nil
    end.compact
  end

end

class PeopleFilterMigrator < RelationMigrator
  def relation_class
    PeopleFilter
  end

  def group_for(relation)
    relation.group
  end
end

class SubscriptionMigrator < RelationMigrator
  def relation_class
    Subscription
  end

  def group_for(relation)
    relation.subscriber
  end

  def current_relations
    super.where(subscriber_type: 'Group')
  end


end

