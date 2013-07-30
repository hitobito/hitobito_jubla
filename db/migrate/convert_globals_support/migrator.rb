# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Migrator < Struct.new(:role_type)

  def perform
    check
    update_roles

    subscription.perform
    filter.perform
  end

  def subscription
    @abo_migrator ||= SubscriptionMigrator.new(role_type)
  end

  def filter
    @filter_migrator ||= PeopleFilterMigrator.new(role_type)
  end

  private

  def check
    group_types_roles_map.values.each(&:constantize)
  end

  def update_roles
    group_types_roles_map.each do |group_type, new_role_type|
      ids = role_type.joins(:group).where(groups: {type: group_type}).map(&:id)
      role_type.where(id: ids).update_all(type: new_role_type)
    end
  end

  def group_types_roles_map
    @group_types_roles_map ||= role_type.joins(:group).pluck(:'groups.type').uniq.each_with_object({}) do |group_type, hash|
      hash[group_type] = "#{group_type}::#{role_type.to_s.demodulize}"
    end
  end
end
