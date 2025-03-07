class RemoveAhvNumberOldFromPerson < ActiveRecord::Migration[7.1]
  def change
    remove_column :people, :ahv_number_old
  end
end
