# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class UpdateLayerGroupId < ActiveRecord::Migration
  def up
    groups_with_bad_layer_group_id = []

    say_with_time("loading all groups") do
      groups_with_bad_layer_group_id = Group.all.select { |group| group.layer_group.id != group.layer_group_id }
    end

    say_with_time("updating layer_group_id for #{groups_with_bad_layer_group_id.count} groups") do
      groups_with_bad_layer_group_id.each do |group|
        say("#{group.name}(#{group.id}) changing layer_group_id from #{group.layer_group_id} to #{group.layer_group.id}")
        group.update_attribute(:layer_group_id, group.layer_group.id)
      end
    end
  end

  def down
  end
end
