#  Copyright (c) 2017-2024, Pfadibewegung Schweiz. This file is part of
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
    return if no_more_active_roles?
    return unless group.is_a?(Group::Flock)

    AlumniMailer.new_member_flock(person).deliver_now
  end

  private

  def no_more_active_roles?
    person.roles.without_alumnus.roles_in_layer(person.id, group.layer_group_id).any?
  end

  def group
    @group ||= Group.find(@group_id)
  end

  def person
    @person ||= Person.find(@person_id)
  end
end
