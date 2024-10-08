#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class GroupOriginator
  FLOCK_ROLES = (Group::Flock.roles - [Group::Flock::External,
    Group::Flock::Coach,
    Group::Flock::Advisor]).map(&:sti_name)

  STATE_ROLES = (Group::StateBoard.roles - [Group::StateBoard::External,
    Group::StateBoard::DispatchAddress] +
                                           [Group::StateAgency::Leader]).map(&:sti_name)

  attr_reader :person, :flock, :state

  def initialize(person)
    @person = person

    @flock = find_with_deleted { |roles| find_flock(roles) || find_flock_via_childgroups(roles) }
    @state = find_with_deleted { |roles| find_state(roles) }

    @state ||= flock.ancestors.where(type: "Group::State").first if flock
  end

  def to_s
    [flock, state].join(", ")
  end

  def to_h
    {originating_flock_id: flock.try(:id), originating_state_id: state.try(:id)}
  end

  private

  def roles
    person.roles.order(:updated_at)
  end

  def find_with_deleted
    yield(roles) || yield(roles.with_inactive)
  end

  def find_flock(roles)
    roles.where(type: FLOCK_ROLES).last.try(:group)
  end

  def find_flock_via_childgroups(roles)
    roles.where(type: Group::ChildGroup.roles.map(&:sti_name)).last.try(:group).try(:parent)
  end

  def find_state(roles)
    roles.where(type: STATE_ROLES).last.try(:group).try(:parent)
  end
end
