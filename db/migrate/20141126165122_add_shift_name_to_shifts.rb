class AddShiftNameToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :shift_name, :string
  end
end
