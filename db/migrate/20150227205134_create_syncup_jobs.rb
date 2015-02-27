class CreateSyncupJobs < ActiveRecord::Migration
  def change
    create_table :syncup_jobs do |t|

      t.timestamps
    end
  end
end
