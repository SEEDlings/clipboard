class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.string :sf_contact_id
      t.string :sf_volunteer_shift_id
      t.string :sf_shift_detail_id
      t.references :volunteer, index: true
      t.references :activity, index: true
      t.string :date
      t.decimal :hours, precision: 12, scale: 2
      t.string :status, default: 'Sign Up'

      t.timestamps
    end
  end
end
