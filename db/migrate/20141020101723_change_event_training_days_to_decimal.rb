class ChangeEventTrainingDaysToDecimal < ActiveRecord::Migration
  def change
    change_column :events, :training_days, :decimal, precision: 12, scale: 1
  end
end
