# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class CensusInvitationJob < BaseJob

  RECIPIENT_ROLES = [Group::StateAgency::Leader,
                     Group::Flock::Leader].freeze


  self.parameters = [:census_id]

  def initialize(census)
    @census_id = census.id
  end

  def perform
    CensusMailer.invitation(census, recipients).deliver_now
  end

  def recipients
    Person.joins(:roles).
      where(roles: { type: RECIPIENT_ROLES.collect(&:sti_name), deleted_at: nil }).
      uniq
  end

  def census
    Census.find(@census_id)
  end

end
