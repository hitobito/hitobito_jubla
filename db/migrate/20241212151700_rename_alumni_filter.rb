# frozen_string_literal: true

class RenameAlumniFilter < ActiveRecord::Migration[7.0]
  def up
    execute "UPDATE people_filters SET name = 'Austritte' WHERE name = 'Ehemalige';"
  end

  def down
    execute "UPDATE people_filters SET name = 'Ehemalige' WHERE name = 'Austritte';"
  end
end
