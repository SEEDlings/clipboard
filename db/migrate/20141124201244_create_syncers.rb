class CreateSyncers < ActiveRecord::Migration
  def change
    create_table :syncers do |t|
      t.string :last_sync
      t.string :last_full_sync

      t.timestamps
    end
  end
end
