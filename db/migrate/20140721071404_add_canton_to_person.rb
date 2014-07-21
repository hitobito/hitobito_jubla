class AddCantonToPerson < ActiveRecord::Migration
  def change
    add_column(:people, :canton, :string)
  end
end
