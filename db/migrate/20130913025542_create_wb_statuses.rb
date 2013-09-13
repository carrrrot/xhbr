class CreateWbStatuses < ActiveRecord::Migration
  def change
    create_table :wb_statuses do |t|
      t.references :wb_target_user, null: false
      t.string :wb_id, null: false
      t.string :wb_mid, null: false
      t.string :wb_idstr, null: false
      t.datetime :posted_at, null: false
      t.text :message, null: false
      t.integer :attitudes_count, null: false
      t.integer :comments_count, null: false
      t.integer :reposts_count, null: false
      t.string :thumbnail_pic, null: false

      t.timestamps
    end
    add_index :wb_statuses, :wb_target_user_id
    add_index :wb_statuses, :wb_id, unique: true
  end
end
