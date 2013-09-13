class CreateWbAccessTokens < ActiveRecord::Migration
  def change
    create_table :wb_access_tokens do |t|
      t.references :wb_user, null: false
      t.string :value, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
    add_index :wb_access_tokens, :wb_user_id
  end
end
