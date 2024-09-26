# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.


require Rails.root.join('db', 'seeds', 'support', 'event_seeder')

srand(42)

class JublaEventSeeder < EventSeeder

  @@conditions = []

  def seed_event(group_id, type)
    values = event_values(group_id)
    case type
    when :course then seed_course(values)
    when :camp then seed_camp(values)
    when :base then seed_base_event(values)
    end
  end

  def seed_camp(values)
    date, number = values[:application_opening_at], values[:number]

    event = Event::Camp.find_or_initialize_by(name: "Lager #{number}")
    event.attributes = values
    event.save(validate: false)

    seed_dates(event, date + 90.days)
    seed_questions(event) if true?
  end

  def seed_course(values)
    event = super(values)

    event.reload
    event.condition_id = @@conditions[event.group_ids.first].shuffle.first
    event.state = Event::Course.possible_states.shuffle.first
    application_contact = event.possible_contact_groups.sample
    event.application_contact_id = application_contact.id
    event.save!
  end

  def seed_event_course_conditions(group_id)
    [:tick, :trick, :track].each do |label|
      data = { group_id: group_id, label: label, content: Faker::Lorem.paragraph(sentence_count: rand(3) + 1) }
      condition = Event::Course::Condition.seed(:group_id, :label, data).first
      @@conditions[group_id] ||= []
      @@conditions[group_id] << condition.id
    end
  end

  def camp_group_ids
    Group.where(type: Group::Flock.sti_name).pluck(:id)
  end

end

seeder = JublaEventSeeder.new
srand(42)

begin
  seeder.course_group_ids.each do |group_id|
    seeder.seed_event_course_conditions(group_id)
    20.times do
      seeder.seed_event(group_id, :course)
      seeder.seed_event(group_id, :base)
    end
  end

  seeder.camp_group_ids.each do |group_id|
    10.times do
      seeder.seed_event(group_id, :base)
      seeder.seed_event(group_id, :camp)
    end
  end

  Event::Participation.update_all(state: 'assigned', active: true)

rescue TypeError => e
  binding.pry
end
