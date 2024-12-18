# frozen_string_literal: true

#  Copyright (c) 2024-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

namespace :nejb do
  task abort_if_deactivated: [:environment] do
    abort "NEJB is not enabled" if FeatureGate.disabled?("groups.nejb")
  end

  task :prepare do
    def say_with_time(message)
      say(message)
      result = nil
      time = Benchmark.measure { result = yield }
      say "%.4fs" % time.real, :subitem
      say("#{result} rows", :subitem) if result.is_a?(Integer)
      result
    end

    def say(message, subitem = false)
      puts "#{subitem ? "   ->" : "--"} #{message}"
    end
  end

  desc "Insert new root-group 'hitobito' to accomodate both Jubla and NEJB"
  task insert_new_root: [:abort_if_deactivated, :prepare, :environment] do
    admin_layer = nil

    say_with_time "Create new root-group" do
      admin_layer_attrs = {
        name: "hitobito",
        type: "Group::Root"
      }

      # find or create by with validate: false
      admin_layer = if Group.exists?(admin_layer_attrs)
        Group.find_by(admin_layer_attrs)
      else
        Group.new(admin_layer_attrs).tap do |g|
          g.save(validate: false)
          g.reload
        end
      end
    end

    say_with_time "Move previous top group below new root-group" do
      Group
        .where(type: "Group::Federation", parent_id: nil)
        .update_all(parent_id: admin_layer.id, lft: nil, rgt: nil)
    end

    say_with_time "Rebuilding nested set..." do
      Group.archival_validation = false
      Group.rebuild!(false)
      Group.archival_validation = true
    end

    say_with_time "Regenerating ordering tables" do
      require Rails.root.join("db", "seeds", "support", "order_table_seeder")
      OrderTableSeeder.new.seed
    end
  end

  namespace :flock_alumnus_groups do
    desc "Merge duplicated Ehemalige-Groups to only have one (with this name) per Group"
    task consolidate: [:abort_if_deactivated, :prepare, :environment] do
      group_type = "Group::FlockAlumnusGroup"
      group_name = "Ehemalige"
      connection = ActiveRecord::Base.connection

      # direct SQL to have detailed control over grouping
      query = <<~SQL
        SELECT parent_id, json_arrayagg(id ORDER BY id ASC) AS ids, count(*) AS count
        FROM groups
        WHERE name = '#{group_name}'
          AND type = '#{group_type}'
          AND deleted_at IS NULL
          AND archived_at IS NULL
        GROUP BY parent_id
        ORDER BY count(*) DESC, parent_id ASC
      SQL

      say_with_time "Consolidating duplicated #{group_name}-groups" do
        connection.select_rows(query).map do |parent_id, ids_json, count|
          next if count == 1

          ids = JSON.parse(ids_json)
          first = ids.shift

          new_group = ids.reduce(Group.find(first)) do |merged, id|
            merger = Group::Merger.new(merged, Group.find(id), merged.name)
            merger.merge!
            merger.new_group
          end

          say "Consolidated #{count} groups into Group##{new_group.id}: #{new_group.name}", true

          count
        end.compact
      end
    end

    desc "Rename 'Ehemalige' to 'Ausgetretene Leitungspersonen'"
    task rename: [:abort_if_deactivated, :prepare, :environment] do
      old_name = "Ehemalige"
      new_name = "Ausgetretene Leitungspersonen"
      the_type = "Group::FlockAlumnusGroup"

      say_with_time "Renaming Alumnus-groups on flock-level" do
        Group
          .where(name: old_name, type: the_type, deleted_at: nil, archived_at: nil)
          .update_all(name: new_name)
      end
    end
  end
end
