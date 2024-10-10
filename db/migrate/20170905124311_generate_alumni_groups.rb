# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.
#
# After this creation of Alumni-Groups, one such group is a default-child and
# therefore created with every new group in the respective layers.
class GenerateAlumniGroups < ActiveRecord::Migration[4.2]

  def up
    Group.reset_column_information

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
        group_class(ALUMNI_GROUPS[l]).create(name: 'Ehemalige', parent_id: g.id)
      end
    end
  end

  def group_class(name)
    "Group::#{name.to_s.camelize}".constantize
  end
end
