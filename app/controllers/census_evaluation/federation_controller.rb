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
        @show_confirmation_ratios = (year == current_year)
        @flocks = flock_confirmation_ratios if @show_confirmation_ratios
      end
      format.csv do
        authorize!(:create, Census)
        send_data csv, type: :csv
      end
    end
  end
  
  private

  def csv
    Export::Csv::Generator.new(Export::CensusFlock.new(year)).csv
  end

  def flock_confirmation_ratios
    @sub_groups.inject({}) do |hash, state|
      hash[state.id] = {confirmed: number_of_confirmations(state), total: number_of_flocks(state)}
      hash
    end
  end
  
  def number_of_confirmations(state)
    MemberCount.where(state_id: state.id, year: year).count(:flock_id, distinct: true)
  end
  
  def number_of_flocks(state)
    state.descendants.where(type: Group::Flock.sti_name).count
  end

end
