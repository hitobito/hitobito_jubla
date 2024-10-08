# == Schema Information
#
# Table name: member_counts
#
#  id        :integer          not null, primary key
#  state_id  :integer          not null
#  flock_id  :integer          not null
#  year      :integer          not null
#  born_in   :integer
#  leader_f  :integer
#  leader_m  :integer
#  child_f   :integer
#  child_m   :integer
#  region_id :integer
#

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class MemberCount < ActiveRecord::Base
  belongs_to :flock, class_name: "Group::Flock"
  belongs_to :state, class_name: "Group::State"
  belongs_to :region, class_name: "Group::Region"

  validates_by_schema
  validates :born_in, uniqueness: {scope: [:flock_id, :year]}
  validates :leader_f, :leader_m, :child_f, :child_m,
    numericality: {greater_than_or_equal_to: 0, allow_nil: true}

  def total
    leader + child
  end

  def leader
    leader_f.to_i + leader_m.to_i
  end

  def child
    child_f.to_i + child_m.to_i
  end

  def f
    leader_f.to_i + child_f.to_i
  end

  def m
    leader_m.to_i + child_m.to_i
  end

  class << self
    def total_by_states(year)
      totals(year, {state_id: nil})
    end

    def total_by_regions(year)
      totals(year, {region_id: nil})
    end

    def total_by_flocks(year, group)
      condition = case group
      when Group::State then {state_id: group.id, flock_id: nil}
      when Group::Region then {region_id: group.id, flock_id: nil}
      end
      totals(year, condition)
    end

    def total_for_federation(year)
      totals(year, {year: nil})[0]
    end

    def total_for_flock(year, flock)
      totals(year, {flock_id: flock.id})[0]
    end

    def details_for_federation(year)
      details(year)
    end

    def details_for_state(year, state)
      details(year).where(state_id: state.id)
    end

    def details_for_region(year, region)
      details(year).where(region_id: region.id)
    end

    def details_for_flock(year, flock)
      details(year).where(flock_id: flock.id)
    end

    def totals(year, criteria)
      selections = criteria.keys + [
        "SUM(leader_f) AS leader_f",
        "SUM(leader_m) AS leader_m",
        "SUM(child_f) AS child_f",
        "SUM(child_m) AS child_m"
      ]
      select(selections.compact.join(", "))
        .where(year: year)
        .where(criteria.compact)
        .group(criteria.keys)
    end

    private

    def details(year)
      totals(year, {born_in: nil}).order(:born_in)
    end
  end
end
