class CreateWbTargetUserFrames < ActiveRecord::Migration
  def change
    create_table :wb_target_user_frames do |t|
      t.references :wb_target_user, null: false
      t.integer :followers_count, default: 0, null: false
      t.integer :statuses_count
      t.integer :favourites_count
      t.float :followers_per_hour
      t.float :followers_per_hour_smoothed

      t.timestamps
    end
    add_index :wb_target_user_frames, [:wb_target_user_id, :created_at], unique: true
  end
end
