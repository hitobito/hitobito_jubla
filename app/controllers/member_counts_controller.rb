# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class MemberCountsController < ApplicationController

  decorates :group

  def edit
    authorize!(:update_member_counts, flock)
    member_counts
  end

  def update
    authorize!(:update_member_counts, flock)

    counts = member_counts.update(
      params[:member_count].keys,
      params[:member_count].values.collect do |attrs|
        ActionController::Parameters.new(attrs).permit(:leader_f, :leader_m, :child_f, :child_m)
      end)
    with_errors = counts.select { |c| c.errors.present? }
    if with_errors.blank?
      flash[:notice] = "Die Mitgliederzahlen für #{year} wurden erfolgreich gespeichert"
      redirect_to census_flock_group_path(flock, year: year)
    else
      messages = with_errors.collect { |e| "#{e.born_in}: #{e.errors.full_messages.join(', ')}" }
      flash.now[:alert] = 'Nicht alle Jahrgänge konnten gespeichert werden. ' \
                          "Bitte überprüfen Sie Ihre Angaben. (#{messages.join('; ')})"
      render 'edit'
    end
  end

  def create
    authorize!(:create_member_counts, flock)

    if year = MemberCounter.create_counts_for(flock)
      total = MemberCount.total_for_flock(year, flock).try(:total) || 0
      flash[:notice] = "Die Zahlen von Total #{total} Mitgliedern wurden " \
                       "für #{year} erfolgreich erzeugt."
    end

    year ||= Time.zone.today.year
    redirect_to census_flock_group_path(flock, year: year)
  end

  private

  def member_counts
    @member_counts ||= flock.member_counts.where(year: year).order(:born_in)
  end

  def flock
    @group ||= Group::Flock.find(params[:group_id])
  end

  def year
    @year ||= if params[:year]
                params[:year].to_i
              else
                fail(ActiveRecord::RecordNotFound, 'year required')
              end
  end
end
