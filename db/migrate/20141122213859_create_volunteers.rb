class CreateVolunteers < ActiveRecord::Migration
  def change
    create_table :volunteers do |t|
      t.string :sf_id
      t.string :name_first
      t.string :name_last
      t.string :email

      t.timestamps
    end
  end
end
