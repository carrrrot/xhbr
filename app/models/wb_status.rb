class WbStatus < ActiveRecord::Base
  belongs_to :wb_target_user
  has_many :wb_status_frames, dependent: :destroy
  accepts_nested_attributes_for :wb_status_frames
  attr_accessible :posted_at, :message, :attitudes_count, :comments_count, :reposts_count
end
