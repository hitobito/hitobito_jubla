class AddAlumnusContactFlagsToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :contactable_by_federation, :boolean, null: false, default: false
    add_column :people, :contactable_by_state,      :boolean, null: false, default: false
    add_column :people, :contactable_by_region,     :boolean, null: false, default: false
  end
end
