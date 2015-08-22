# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'csv'

class Event::Course::BsvInfo::Row
  attr_reader :info, :course

  delegate :number, :training_days, :dates, to: :course
  delegate :kurs_id_fiver, :location, :training_days, :warnings, to: :info
  delegate :date, :cantons, :cooks, :speakers, :leaders_total, :total_days, :error, to: :info

  def initialize(course)
    @course = course
    @info = Bsv::Info.new(course)
  end

  def leaders
    info.leaders_count
  end

  def participants
    info.participants_aged_17_to_30.count
  end

  def vereinbarung_id_fiver
    info.vereinbarungs_id_fiver
  end

  def languages
  end

  def participants_total
    info.participations_for(course.participant_types).map(&:person).count
  end

  def location
    max_duration_date = course.dates.
      select { |date| date.location.present? }.
      max { |a, b| a.duration.days <=> b.duration.days }

    max_duration_date ? max_duration_date.location : info.location
  end

end
