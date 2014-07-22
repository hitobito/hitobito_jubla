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

    self.used_attributes += [:advisor_id, :application_contact_id, :condition_id, :training_days]

    # states are used for workflow
    # translations in config/locales
    self.possible_states = %w(created confirmed application_open application_closed
                              assignment_closed canceled completed closed)

    ### ASSOCIATIONS

    belongs_to :application_contact, class_name: 'Group'
    belongs_to :condition, class_name: 'Condition'

    ### VALIDATIONS

    validates :state, inclusion: possible_states

    validate :validate_application_contact

    # Define methods to query if a course is in the given state.
    # eg course.canceled?
    possible_states.each do |state|
      define_method "#{state}?" do
        self.state == state
      end
    end

  end

  # may participants apply now?
  def application_possible?
    application_open? &&
    (!application_opening_at || application_opening_at <= ::Date.today)
  end

  def qualification_possible?
    !completed? && !closed?
  end

  def state
    super || possible_states.first
  end

  def possible_contact_groups
    groups.each_with_object([]) do |g, contact_groups|
      if type = g.class.contact_group_type
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

  module ClassMethods
    def application_possible
      where(state: 'application_open').
      where('events.application_opening_at IS NULL OR events.application_opening_at <= ?', ::Date.today)
    end
  end

end
