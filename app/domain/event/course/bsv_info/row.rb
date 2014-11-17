
# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'csv'

class Event::Course::BsvInfo::Row
  attr_reader :course, :leaders, :leaders_total, :participants, :participants_total, :cooks, :speakers,
    :cantons, :warnings, :vereinbarung_id_fiver, :languages

  delegate :number, :training_days, :dates, to: :course

  CANTONS = I18n.t('activerecord.attributes.person.cantons').keys.map(&:to_s)

  def initialize(course)
    @course = course

    @date = dates.first.start_at.to_date if dates.present?

    @participations = course.participations.where(active: true).includes(:person, :roles)
    @participants_people = participations_for(*course.participant_types).map(&:person)

    @leaders = participations_for(Event::Role::Leader, Event::Role::AssistantLeader).count
    @leaders_total = participations_for(*roles_without_participants_and_advisors).count
    @cooks = participations_for(Event::Role::Cook).count
    @speakers = participations_for(Event::Role::Speaker).count

    @participants = participants_aged_17_to_30.count if @date
    @participants_total = @participants_people.count

    @cantons = valid_cantons_count(participants_aged_17_to_30.map(&:canton))
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

  def roles_without_participants_and_advisors
    course.role_types - course.participant_types - [Event::Course::Role::Advisor]
  end

  def participants_aged_17_to_30
    @participants_aged_17_to_30 ||= @participants_people.
      select(&:birthday?).
      select { |person| (17..30).cover?(@date.year - person.birthday.year) }
  end

  def valid_cantons_count(cantons)
    cantons.select { |canton| CANTONS.include?(canton.to_s.downcase) }.uniq.count
  end

  def compute_warnings
    birthdays = @participants_people.map(&:birthday)
    cantons = @participants_people.map(&:canton)

    { participants: birthdays.any?(&:blank?),
      cantons: cantons.any? { |canton| !CANTONS.include?(canton.to_s.downcase) } }
  end
end
