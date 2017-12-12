# encoding: utf-8
# frozen_string_literal: true

#  Copyright (c) 2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class AddRegionalCensus < ActiveRecord::Migration
  def change
    add_column :member_counts, :region_id, :integer

    reversible do |dir|
      dir.up do
        say_with_time "Infer Region where available" do
          suppress_messages do
            execute <<-SQL.strip_heredoc
              UPDATE member_counts
              SET region_id = (
                SELECT regions.id
                FROM groups
                INNER JOIN groups AS regions ON ( groups.parent_id = regions.id AND regions.type = 'Group::Region' )
                WHERE groups.id = member_counts.flock_id
              )
            SQL
          end
        end
      end
    end

    add_index :member_counts, [:region_id, :year]
  end
end
