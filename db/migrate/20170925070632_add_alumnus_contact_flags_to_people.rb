class AddAlumnusContactFlagsToPeople < ActiveRecord::Migration
  def change
    add_column(:people, :contactable_by_federation, :boolean)
    add_column(:people, :contactable_by_state, :boolean)
    add_column(:people, :contactable_by_region, :boolean)
  end
end
