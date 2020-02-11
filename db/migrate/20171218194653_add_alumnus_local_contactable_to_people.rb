class AddAlumnusLocalContactableToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :contactable_by_flock, :boolean, null: false, default: false
  end
end
