#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Export::Tabular
  class CensusFlockList
    def initialize(year, flock_id = nil)
      @year = year
      @flock_id = flock_id
    end

    def entries
      member_counts = build_member_counts

      query_flocks.map do |flock|
        build_item(flock, member_counts[flock.id])
      end
    end

    private

    def build_member_counts
      query_member_counts.each_with_object(Hash.new(null_member_count)) do |item, hash|
        hash[item.flock_id] = item
      end
    end

    def query_flocks
      ::Group::Flock.includes(:contact).order("groups.name")
    end

    def query_member_counts
      ::MemberCount.totals(@year, {flock_id: @flock_id})
    end

    # rubocop:todo Metrics/AbcSize
    def build_item(flock, member_count) # rubocop:disable Metrics/MethodLength
      # rubocop:todo Layout/LineLength
      {state: (flock.parent.parent.type == "Group::State") ? flock.parent.parent.name : flock.parent.name,
       # rubocop:enable Layout/LineLength
       region: (flock.parent.type == "Group::Region") ? flock.parent.name : "",
       name: flock.name,
       contact_first_name: flock.contact&.first_name,
       contact_last_name: flock.contact&.last_name,
       address: flock.address,
       zip_code: flock.zip_code,
       town: flock.town,
       jubla_property_insurance: flock.jubla_property_insurance,
       jubla_liability_insurance: flock.jubla_liability_insurance,
       jubla_full_coverage: flock.jubla_full_coverage,
       leader_count: member_count.leader,
       child_count: member_count.child}
    end
    # rubocop:enable Metrics/AbcSize

    def null_member_count
      Struct.new(:leader, :child).new(nil, nil)
    end
  end
end
