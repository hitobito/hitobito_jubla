# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::Course
  extend ActiveSupport::Concern

  included do
    include Event::RestrictedRole
    restricted_role :advisor, Event::Course::Role::Advisor

    self.used_attributes += [:advisor_id, :application_contact_id, :condition_id]

    ### ASSOCIATIONS

    belongs_to :application_contact, class_name: 'Group'
    belongs_to :condition, class_name: 'Condition'

    ### VALIDATIONS

    validate :validate_application_contact

    validates :training_days, modulus: { multiple: 0.5 }, numericality: { allow_nil: true }
  end

  def possible_contact_groups
    groups.each_with_object([]) do |g, contact_groups|
      type = g.class.contact_group_type
      if type
        children = g.children.where(type: type.sti_name).without_deleted
        contact_groups.concat(children)
      end
    end
  end

  private

  def validate_application_contact
    unless possible_contact_groups.include?(application_contact)
      errors.add(:application_contact_id, 'muss definiert sein')
    end
  end

end
