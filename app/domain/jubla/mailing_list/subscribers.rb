# encoding: utf-8

#  Copyright (c) 2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::MailingList::Subscribers
  extend ActiveSupport::Concern

  included do
    alias_method_chain :excluded_person_subscribers, :preferences
  end

  private

  def excluded_person_subscribers_with_preferences
    SqlString.new(<<-SQL)
      (
        #{excluded_person_subscribers_without_preferences.to_sql}
        UNION
        #{excluded_by_contact_preference.to_sql}
      )
    SQL
  end

  def excluded_by_contact_preference
    Person.alumnus_only.where(:"contactable_by_#{layer_type}" => false).select(:id)
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
