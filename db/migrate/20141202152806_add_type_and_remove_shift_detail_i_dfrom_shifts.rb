class AddTypeAndRemoveShiftDetailIDfromShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :type, :string
    remove_column :shifts, :sf_shift_detail_id
  end
end
