class AddDomainColumnToWbTargetUser < ActiveRecord::Migration
  def change
  	add_column :wb_target_users, :domain, :string
  end
end
