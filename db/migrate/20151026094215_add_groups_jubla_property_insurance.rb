class AddGroupsJublaPropertyInsurance < ActiveRecord::Migration
  def change
    add_column :groups, :jubla_property_insurance, :boolean, null: false, default: false
    rename_column :groups, :jubla_insurance, :jubla_liability_insurance
  end
end
