# encoding: utf-8

#  Copyright (c) 2012-2015, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::ActionHelper
  extend ::ActionHelper

  def button_action_signout( options={} )
    path = group_event_participation_path(params[:group_id], entry.id, 
            entry.participations.where(person_id: current_user.id, 
            event_id: params[:id]).first.id )
    options[:data] = { confirm: ti(:confirm_signout),
                       method: :delete }
    action_button ti(:"link.signout"), path, 'trash', options
  end

end
