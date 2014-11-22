class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.string :date
      t.references :event, index: true

      t.timestamps
    end
  end
end
