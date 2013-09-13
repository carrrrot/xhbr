class CreateWbUsers < ActiveRecord::Migration
  def change
    create_table :wb_users do |t|
      t.integer :wb_id, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :wb_users, :wb_id, unique: true
  end
end
