class AddStateToSyncer < ActiveRecord::Migration
  def change
    add_column :syncers, :state, :string
  end
end
