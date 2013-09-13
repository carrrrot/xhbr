class CreateWbStatusFrames < ActiveRecord::Migration
  def change
    create_table :wb_status_frames do |t|
      t.references :wb_status, null: false
      t.integer :attitudes_count, null: false
      t.integer :comments_count, null: false
      t.integer :reposts_count, null: false

      t.timestamps
    end
    add_index :wb_status_frames, [:wb_status_id, :created_at], unique: true
  end
end
