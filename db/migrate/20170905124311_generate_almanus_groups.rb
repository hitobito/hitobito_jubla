# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.
#
class GenerateAlmanusGroups < ActiveRecord::Migration

  def up
    say_with_time 'Generating Alumni-Groups' do
      generate_groups
    end
  end

  private

  LAYERS = [:federation, :flock, :region, :state].freeze
  ALUMNI_GROUPS = {
    federation: :federal_alumnus_group,
    flock:      :flock_alumnus_group,
    region:     :regional_alumnus_group,
    state:      :state_alumnus_group
  }.freeze

  def generate_groups
    LAYERS.each do |l|
      group_class(l).find_each do |g|
        group_class(ALUMNI_GROUPS[l]).create(name: 'Ehemalig', parent_id: g.id)
      end
    end
  end

  def group_class(name)
    "Group::#{name.to_s.camelize}".constantize
  end
end
