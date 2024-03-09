# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.


module Export::Tabular
  class CensusFlockState < Export::Tabular::Base

    class Row < Export::Tabular::Row
      def value_for(attr)
        entry.fetch(attr)
      end
    end

    self.model_class = Group::Flock
    self.row_class = Row

    def initialize(year)
      @year = year
      super(build_items)
    end

    private

    def build_items
      member_counts = build_member_counts

      query_flocks.map do |flock|
        build_item(flock, member_counts[flock.id])
      end
    end

    def build_member_counts
      query_member_counts.each_with_object(Hash.new(null_member_count)) do |item, hash|
        hash[item.flock_id] = item
      end
    end

    def query_flocks
      ::Group::Flock.includes(:contact).order('groups.name')
    end

    def query_member_counts
      ::MemberCount.totals(@year).group(:flock_id)
    end

    def build_item(flock, member_count) # rubocop:disable Metrics/MethodLength
      { name: flock.name,
        leader_count: member_count.leader,
        child_count: member_count.child }
    end

    def build_attribute_labels # rubocop:disable Metrics/MethodLength
      { name: human_attribute(:name),
        leader_count: 'Leitende',
        child_count: 'Kinder' }
    end

    def null_member_count
      Struct.new(:leader, :child).new(nil, nil)
    end

  end
end