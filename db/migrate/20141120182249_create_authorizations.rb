class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :instance_url
      t.string :oauth_token
      t.string :refresh_token

      t.timestamps
    end
  end
end
