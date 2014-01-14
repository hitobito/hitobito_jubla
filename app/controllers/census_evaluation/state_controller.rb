# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class CensusEvaluation::StateController < CensusEvaluation::BaseController

  self.sub_group_type = Group::Flock

  def remind
    authorize!(:remind_census, group)

    flock = evaluation.sub_groups.find(params[:flock_id])
    CensusReminderJob.new(current_user, evaluation.current_census, flock).enqueue!
    notice = "Erinnerungsemail an #{flock.to_s} geschickt"

    respond_to do |format|
      format.html { redirect_to census_state_group_path(group), notice: notice }
      format.js { flash.now.notice = notice }
    end
  end

end
