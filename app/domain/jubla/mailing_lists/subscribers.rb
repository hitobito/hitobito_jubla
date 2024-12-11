# frozen_string_literal: true

#  Copyright (c) 2017-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::MailingLists::Subscribers
  extend ActiveSupport::Concern

  included do
    alias_method_chain :excluded_subscriber_ids, :preferences
  end

  private

  def excluded_subscriber_ids_with_preferences
    SqlString.new(<<-SQL)
      (
        #{excluded_subscriber_ids_without_preferences.to_sql}
        UNION
        #{excluded_by_contact_preference.to_sql}
      )
    SQL
  end

  def excluded_by_contact_preference
    preference_column = "contactable_by_#{layer_type}"
    return Person.none.select(:id) unless Person.column_names.include?(preference_column)

    Person.alumnus_only.where("#{preference_column}": false).select(:id)
  end

  def layer_type
    @list.group.layer_group.type.demodulize.underscore
  end

  SqlString = Struct.new(:sql) do
    def to_sql
      sql
    end
  end
end
