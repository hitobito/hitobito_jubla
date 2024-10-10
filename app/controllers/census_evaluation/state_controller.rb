#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class CensusEvaluation::StateController < CensusEvaluation::BaseController
  include AsyncDownload

  self.sub_group_type = Group::Flock

  before_action :check_authorization, only: [:remind]

  def remind
    flock = evaluation.sub_groups.find(params[:flock_id])
    CensusReminderJob.new(current_user, evaluation.current_census, flock).enqueue!
    notice = "Erinnerungsemail an #{flock} geschickt"

    respond_to do |format|
      format.html { redirect_to census_state_group_path(group), notice: notice }
      format.js { flash.now.notice = notice }
    end
  end

  def index
    authorize!(:create, Census)

    respond_to do |format|
      format.html do
        super
      end
      format.csv do
        render_tabular_in_background(:csv, "state")
      end
    end
  end

  private

  def render_tabular_in_background(format, type = nil, file = :census_flock_export)
    with_async_download_cookie(format, file) do |filename|
      Export::CensusFlockExportJob.new(format,
        current_person.id,
        year,
        {type: type, filename: filename}).enqueue!
    end
  end

  def flock_confirmation_ratios
    @sub_groups.each_with_object({}) do |state, hash|
      hash[state.id] = {confirmed: number_of_confirmations(state), total: number_of_flocks(state)}
    end
  end

  def number_of_confirmations(state)
    MemberCount.where(state_id: state.id, year: year)
      .distinct
      .count(:flock_id)
  end

  def number_of_flocks(state)
    state.descendants.without_deleted.where(type: Group::Flock.sti_name).count
  end

  def check_authorization
    authorize!(:remind_census, group)
  end
end
