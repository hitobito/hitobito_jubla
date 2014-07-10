class AddRemarksAndSignatureToEvent < ActiveRecord::Migration
  def change
    add_column(:events, :signature, :boolean)
    add_column(:events, :signature_confirmation, :boolean)
    add_column(:events, :signature_confirmation_text, :string)
    add_column(:events, :remarks, :text)
  end
end
