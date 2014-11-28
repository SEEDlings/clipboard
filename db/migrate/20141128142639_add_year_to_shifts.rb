class AddYearToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :year, :string
  end
end
