class CreateSyncers < ActiveRecord::Migration
  def change
    create_table :syncers do |t|
      t.string :last_sync, default: "1000-01-01T00:00:00Z"
      t.string :last_full_sync, default: "1000-01-01T00:00:00Z"

      t.timestamps
    end
  end
end
