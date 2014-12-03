class RemoveDefaultStatusFromShift < ActiveRecord::Migration
  def change
    change_column_default :shifts, :status, nil
  end
end
