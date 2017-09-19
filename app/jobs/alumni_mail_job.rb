# encoding: utf-8

#  Copyright (c) 2017, Pfadibewegung Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class AlumniMailJob < BaseJob

  self.parameters = [:group_id, :person_id]

  def initialize(group_id, person_id)
    @group_id = group_id
    @person_id = person_id
  end

  def perform
    alumni_roles = Group::ALUMNI_GROUPS_CLASSES.map { |c| "#{c}::Member".constantize }
    return if person.roles.where.not(type: alumni_roles).any?

    if group.is_a?(Group::Flock)
      AlumniMailer.new_member_flock(person).deliver_now
    else
      AlumniMailer.new_member(person).deliver_now
    end
  end

  private

  def group
    Group.find(@group_id)
  end

  def person
    @person ||= Person.find(@person_id)
  end

end
