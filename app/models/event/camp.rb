# == Schema Information
#
# Table name: events
#
#  id                          :integer          not null, primary key
#  type                        :string(255)
#  name                        :string(255)      not null
#  number                      :string(255)
#  motto                       :string(255)
#  cost                        :string(255)
#  maximum_participants        :integer
#  contact_id                  :integer
#  description                 :text(65535)
#  location                    :text(65535)
#  application_opening_at      :date
#  application_closing_at      :date
#  application_conditions      :text(65535)
#  kind_id                     :integer
#  state                       :string(60)
#  priorization                :boolean          default(FALSE), not null
#  requires_approval           :boolean          default(FALSE), not null
#  created_at                  :datetime
#  updated_at                  :datetime
#  participant_count           :integer          default(0)
#  application_contact_id      :integer
#  external_applications       :boolean          default(FALSE)
#  applicant_count             :integer          default(0)
#  teamer_count                :integer          default(0)
#  signature                   :boolean
#  signature_confirmation      :boolean
#  signature_confirmation_text :string(255)
#  creator_id                  :integer
#  updater_id                  :integer
#  applications_cancelable     :boolean          default(FALSE), not null
#  required_contact_attrs      :text(65535)
#  hidden_contact_attrs        :text(65535)
#  display_booking_info        :boolean          default(TRUE), not null
#  training_days               :decimal(12, 1)
#  tentative_applications      :boolean          default(FALSE), not null
#  condition_id                :integer
#  remarks                     :text(65535)
#

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Event::Camp < Event
  # This statement is required because this class would not be loaded otherwise.
  require_dependency "event/camp/role/coach"
  require_dependency "event/camp/kind"
  require_dependency "event/camp/kinds_controller"

  self.used_attributes += [:number, :coach_id, :kind_id]

  self.kind_class = Event::Camp::Kind

  include Event::RestrictedRole
  restricted_role :coach, Event::Camp::Role::Coach

  belongs_to :kind, class_name: "Event::Camp::Kind"

  scope :in_next, ->(duration) {
    timespan = duration.from_now.to_date
    where("event_dates.start_at <= ? OR event_dates.finish_at <= ?", timespan, timespan)
  }
end
