class AddGroupsJublaPropertyInsurance < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :jubla_property_insurance, :boolean, null: false, default: false
    rename_column :groups, :jubla_insurance, :jubla_liability_insurance
  end
end
