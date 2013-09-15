class AddLinkIndexToWbTargetUsers < ActiveRecord::Migration
  def change
  	add_index :wb_target_users, :link, unique: true
  end
end
