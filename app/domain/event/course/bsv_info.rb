# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'csv'

class Event::Course::BsvInfo
  attr_reader :course, :leaders, :leaders_total, :participants, :participants_total, :cooks, :speakers,
    :cantons, :warnings

  delegate :number, :training_days, :dates, to: :course

  class List < Export::Csv::Base
    def to_csv(generator)
      list.each do |entry|
        generator << values(entry)
      end
    end

    # we have to two nil fields, ver_id_fiver and languages
    def values(entry)
      info = Event::Course::BsvInfo.new(entry)

      [nil, info.kurs_id_fiver,
       info.number, info.date, info.location, info.training_days,
       info.participants, info.leaders,
       info.cantons, nil,
       info.total_days, info.participants_total,
       info.leaders_total, info.cooks, info.speakers]
    end
  end

  def initialize(course)
    @course = course

    @date = dates.first.start_at.to_date if dates.present?

    @participations = course.participations.includes(:person, :roles)
    @participants_people = participations_for(course.participant_type).map(&:person)

    @leaders = participations_for(Event::Role::Leader, Event::Role::AssistantLeader).count
    @leaders_total = participations_for(*(course.role_types - [course.participant_type])).count
    @cooks = participations_for(Event::Role::Cook).count
    @speakers = participations_for(Event::Role::Speaker).count

    @participants = participants_aged_17_to_30.count if @date
    @participants_total = @participants_people.count

    @cantons = valid_cantons.count
    @warnings = compute_warnings
  end

  def date
    I18n.l(@date) if dates.present?
  end

  def kurs_id_fiver
    course.kind.bsv_id
  end

  def location
    max_duration_date = course.dates.
      select { |date| date.location.present? }.
      max { |a, b| a.duration.days <=> b.duration.days }
    max_duration_date.location if max_duration_date
  end

  def total_days
    dates.map(&:duration).map(&:days).reduce(&:+)
  end

  def label(key)
    { total_days: 'Kurstage',
      participants: 'Teilnehmende (17-30)',
      leaders: 'Kursleitende',
      cantons: 'Wohnkantone der TN',
      participants_total: 'Teilnehmende Total',
      leaders_total: 'Leitungsteam Total',
      cooks: 'Küchenteam',
      speakers: 'Referenten' }.fetch(key)
  end

  def error(key)
    { cantons: 'Nicht alle Teilnehmer haben einen gültigen Kanton gesetzt.',
      participants: 'Nicht alle Teilnehmer haben den Geburtstag gestetzt.' }.fetch(key)
  end

  private

  # participations for roles
  def participations_for(*role_types)
    @participations.
      select do |participation|
        participation.roles.any? { |role| role_types.include?(role.class) }
    end
  end

  def participants_aged_17_to_30
    range = ((@date - 30.years)..(@date - 17.years))
    @participants_people.
      select { |person| person.birthday && range.cover?(person.birthday) }
  end

  def valid_cantons
    names = I18n.t('activerecord.attributes.person.cantons').keys.map(&:to_s)
    @participants_people.map(&:canton).select { |canton| names.include?(canton.to_s.downcase) }
  end

  def compute_warnings
    {
      participants: @participants_people.map(&:birthday).any?(&:blank?),
      cantons: (@participants_people.count - cantons) > 0
    }
  end
end
