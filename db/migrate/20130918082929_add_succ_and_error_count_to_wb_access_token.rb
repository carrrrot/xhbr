class AddSuccAndErrorCountToWbAccessToken < ActiveRecord::Migration
  def change
    add_column :wb_access_tokens, :success_count, :integer, null: false, default: 0
    add_column :wb_access_tokens, :error_count, :integer, null: false, default: 0
  end
end
