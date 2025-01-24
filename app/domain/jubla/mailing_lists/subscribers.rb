# frozen_string_literal: true

#  Copyright (c) 2017-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::MailingLists::Subscribers
  extend ActiveSupport::Concern

  def subscribed?(person)
    super && excluded_by_contact_preference.where(id: person.id).empty?
  end

  def people_as_configured
    super.where.not(id: excluded_by_contact_preference.select(:id))
  end

  private

  def excluded_by_contact_preference
    preference_column = "contactable_by_#{layer_type}"
    return Person.none.select(:id) unless Person.column_names.include?(preference_column)

    Person.alumnus_only.where("#{preference_column}": false).select(:id)
  end

  def layer_type
    @list.group.layer_group.type.demodulize.underscore
  end
end
