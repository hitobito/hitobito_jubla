# encoding: utf-8
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
#  description                 :text
#  location                    :text
#  application_opening_at      :date
#  application_closing_at      :date
#  application_conditions      :text
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
#  condition_id                :integer
#  signature                   :boolean
#  signature_confirmation      :boolean
#  signature_confirmation_text :string(255)
#  remarks                     :text
#  training_days               :integer
#  teamer_count                :integer          default(0)
#  tentative_applications      :boolean          default(FALSE), not null
#  creator_id                  :integer
#  updater_id                  :integer
#


#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Event::Camp < Event

  # This statement is required because this class would not be loaded otherwise.
  require_dependency 'event/camp/role/coach'
  require_dependency 'event/camp/kind'
  require_dependency 'event/camp/kinds_controller'

  class_attribute :unparticipation_possible

  self.unparticipation_possible = true
  self.used_attributes += [:number, :coach_id, :kind_id]

  self.kind_class = Event::Camp::Kind

  include Event::RestrictedRole
  restricted_role :coach, Event::Camp::Role::Coach

  belongs_to :kind, class_name: 'Event::Camp::Kind'

end
