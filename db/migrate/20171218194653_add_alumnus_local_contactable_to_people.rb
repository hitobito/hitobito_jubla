class AddAlumnusLocalContactableToPeople < ActiveRecord::Migration
  def change
    add_column :people, :contactable_by_flock, :boolean, null: false, default: false
  end
end
