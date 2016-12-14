class AddUnparticipationEnabledToEvent < ActiveRecord::Migration
  def change
    add_column :events, :unparticipation_enabled, :boolean, default: false
  end
end
