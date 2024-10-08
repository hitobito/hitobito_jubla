#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class MemberCounter
  # Ordered mapping of which roles count in which field.
  # If a role from a field appearing first exists, this
  # one is counted, even if other roles exist as well.
  # E.g. Person has roles Group::Biber::Mitleitung and
  # Group::Pio::Pio => counted as :leiter
  #
  # Roles not appearing here are not counted at all.
  ROLE_MAPPING =
    {leader: [Group::Flock::Leader,
      Group::Flock::CampLeader,
      Group::Flock::President,
      Group::Flock::Treasurer,
      Group::Flock::Guide,
      Group::ChildGroup::Leader].map(&:sti_name),
     child: [Group::ChildGroup::Child].map(&:sti_name)}.freeze

  attr_reader :year, :flock

  class << self
    def create_counts_for(flock)
      census = Census.current
      if census && !current_counts?(flock, census)
        new(census.year, flock).count!
        census.year
      else
        false
      end
    end

    def current_counts?(flock, census = Census.current)
      census && new(census.year, flock).exists?
    end

    def counted_roles
      ROLE_MAPPING.values.flatten
    end
  end

  # create a new counter for with the given year and flock.
  # beware: the year is only used to store the results and does not
  # specify which roles to consider - only currently not deleted roles are counted.
  def initialize(year, flock)
    @year = year
    @flock = flock
  end

  def count!
    MemberCount.transaction do
      members_by_year.each do |born_in, people|
        count = new_member_count(born_in)
        count_members(count, people)
        count.save!
      end
    end
  end

  def exists?
    MemberCount.where(flock_id: flock.id, year: year).exists?
  end

  def state
    @state ||= flock.state
  end

  def region
    @region ||= flock.region
  end

  def members
    Person.joins(:roles)
      .where(roles: {group_id: flock.self_and_descendants,
                     type: self.class.counted_roles,
                     end_on: [nil, ..Time.zone.today]})
      .distinct
  end

  private

  def members_by_year
    members.includes(:roles).group_by { |p| p.birthday.try(:year) }
  end

  def new_member_count(born_in)
    count = MemberCount.new
    count.flock = flock
    count.state = state
    count.region = region
    count.year = year
    count.born_in = born_in
    count
  end

  def count_members(count, people)
    people.each do |person|
      increment(count, count_field(person))
    end
  end

  def count_field(person)
    ROLE_MAPPING.each do |field, roles|
      if (person.roles.collect(&:class).map(&:sti_name) & roles).present?
        return (person.gender == "m") ? :"#{field}_m" : :"#{field}_f"
      end
    end
    nil
  end

  def increment(count, field)
    return unless field
    val = count.send(field)
    count.send(:"#{field}=", val ? val + 1 : 1)
  end
end
