# encoding: utf-8

#  Copyright (c) 2012-2015, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::ActionHelper
  extend ::ActionHelper

  def action_button_unparticipate( options={} )
    participation = entry.participations.where(person: current_user).first
    path = group_event_participation_path(parent,
                                          entry,
                                          participation)
    options[:data] = { confirm: t('event.participations.unparticipate.confirm_unparticipation'),
                       method: :delete }
    action_button t('event.participations.unparticipate.unparticipate'), path, 'trash', options
  end

end
