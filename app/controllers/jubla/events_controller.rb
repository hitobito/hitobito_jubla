#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::EventsController
  extend ActiveSupport::Concern

  included do
    before_action :remove_restricted, only: [:create, :update]

    self.permitted_attrs += [:remarks]

    before_render_new :default_coach
    before_render_new :set_application_default_values

    before_render_form :application_contacts
    before_render_form :load_conditions

    before_save :set_application_contact
  end

  private

  def set_application_default_values
    return unless entry.course?

    [:participations_visible, :requires_approval, :signature, :signature_confirmation,
      :display_booking_info].each do
      entry.public_send(:"#{_1}=", true)
    end
    entry.waiting_list = false
  end

  def default_coach
    if entry.class.attr_used?(:coach_id)
      entry.coach_id = parent.coach_id
    end
  end

  def set_application_contact
    if entry.class.attr_used?(:application_contact_id)
      if model_params[:application_contact_id].blank? || application_contacts.count == 1
        entry.application_contact = application_contacts.first
      end
    end
  end

  def application_contacts
    if entry.class.attr_used?(:application_contact_id)
      @application_contacts ||= entry.possible_contact_groups
    end
  end

  def load_conditions
    if entry.is_a?(Event::Course)
      @conditions = Event::Course::Condition.where(group_id: entry.group_ids).order(:label)
    end
  end

  def remove_restricted
    model_params.delete(:advisor)
    model_params.delete(:coach)
  end
end
