class RenameTypeForShifts < ActiveRecord::Migration
  def change
    rename_column :shifts, :type, :shift_type
  end
end
