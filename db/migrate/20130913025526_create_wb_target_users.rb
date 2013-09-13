class CreateWbTargetUsers < ActiveRecord::Migration
  def change
    create_table :wb_target_users do |t|
      t.integer :wb_id, null: false
      t.string :name, null: false
      t.string :link, null: false
      t.text :description, null: false
      t.string :profile_img_link, null: false
      t.integer :followers_count, default: 0, null: false
      t.integer :friends_count
      t.integer :statuses_count
      t.integer :favourites_count
      t.boolean :verified, null: false
      t.text :verified_reason
      t.string :lang

      t.timestamps
    end
    add_index :wb_target_users, :wb_id, unique: true
  end
end
