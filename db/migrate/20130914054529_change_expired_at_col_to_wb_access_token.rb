class ChangeExpiredAtColToWbAccessToken < ActiveRecord::Migration
  def change
  	change_column :wb_access_tokens, :expires_at, :integer, null: false
  end
end
