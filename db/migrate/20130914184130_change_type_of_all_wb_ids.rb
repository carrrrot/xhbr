class ChangeTypeOfAllWbIds < ActiveRecord::Migration
  def change
  	change_column :wb_users, :wb_id, :bigint, null: false
  	change_column :wb_target_users, :wb_id, :bigint, null: false
  	change_column :wb_access_tokens, :wb_user_id, :bigint, null: false
  	change_column :wb_statuses, :wb_target_user_id, :bigint, null: false
  	change_column :wb_target_user_frames, :wb_target_user_id, :bigint, null: false
  	change_column :wb_status_frames, :wb_status_id, :bigint, null: false
  end
end
