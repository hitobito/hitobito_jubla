class AddSignoutActiveToEvent < ActiveRecord::Migration
  def change
    add_column :events, :signout_active, :boolean, default: false
  end
end
