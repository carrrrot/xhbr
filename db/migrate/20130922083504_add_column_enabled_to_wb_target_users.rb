class AddColumnEnabledToWbTargetUsers < ActiveRecord::Migration
  def change
    add_column :wb_target_users, :enabled, :boolean, default: true
  end
end
