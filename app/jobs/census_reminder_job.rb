# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class CensusReminderJob < BaseJob

  self.parameters = [:census, :sender_id, :flock_id]

  attr_reader :census, :sender_id

  def initialize(sender, census, flock)
    @census = census
    @sender_id = sender.id
    @flock_id = flock.id
  end

  def perform
    r = recipients.to_a
    CensusMailer.reminder(sender, census, r, flock, state_agency).deliver_now if r.present?
  end

  def recipients
    flock.people.only_public_data.
      where(roles: { type: Group::Flock::Leader.sti_name }).
      where("email IS NOT NULL OR email <> ''").
      uniq
  end

  def flock
    @flock ||= Group::Flock.find(@flock_id)
  end

  def sender
    @sender ||= Person.find(@sender_id)
  end

  def state_agency
    state = flock.state
    state.children.where(type: state.contact_group_type.sti_name).
      without_deleted.
      first
  end
end
