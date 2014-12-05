class AddEmergencyInfoToVolunteers < ActiveRecord::Migration
  def change
    add_column :volunteers, :emergency_contact_name, :string
    add_column :volunteers, :emergency_contact_phone, :string
    add_column :volunteers, :notes, :text
  end
end
