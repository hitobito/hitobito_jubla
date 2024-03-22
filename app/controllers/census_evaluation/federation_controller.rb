# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class CensusEvaluation::FederationController < CensusEvaluation::BaseController

  self.sub_group_type = Group::State

  def index
    super

    respond_to do |format|
      format.html do
        @flocks = flock_confirmation_ratios if evaluation.current_census_year?
      end
      format.csv do
        if params[:type] == 'kantone'
            authorize!(:create, Census)
            send_data Export::Tabular::CensusFlockFederation.csv(year), type: :csv
        else
            authorize!(:create, Census)
            send_data Export::Tabular::CensusFlock.csv(year), type: :csv
        end
      end
    end
  end

  private

  def flock_confirmation_ratios
    @sub_groups.each_with_object({}) do |state, hash|
      hash[state.id] = { confirmed: number_of_confirmations(state), total: number_of_flocks(state) }
    end
  end

  def number_of_confirmations(state)
    MemberCount.where(state_id: state.id, year: year).
      distinct.
      count(:flock_id)
  end

  def number_of_flocks(state)
    state.descendants.without_deleted.where(type: Group::Flock.sti_name).count
  end

end
