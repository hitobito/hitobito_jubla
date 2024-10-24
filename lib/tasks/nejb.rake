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
end
