#  Copyright (c) 2017-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::Person::Filter::List
  extend ActiveSupport::Concern

  included do
    alias_method_chain :accessibles, :excluded
  end

  private

  def accessibles_with_excluded
    accessibles_without_excluded.where.not(people: {id: excluded_people_ids})
  end

  def excluded_people_ids
    layer_type = group.layer_group.type.demodulize.underscore

    preference_column = "contactable_by_#{layer_type}"
    return Person.none unless Person.column_names.include?(preference_column)

    Person.alumnus_only.where("#{preference_column}": false).pluck(:id)
  end
end
