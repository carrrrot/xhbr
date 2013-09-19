class WbStatus < ActiveRecord::Base
  belongs_to :wb_target_user
  has_many :wb_status_frames, dependent: :destroy
  accepts_nested_attributes_for :wb_status_frames
  attr_accessible :wb_id, :wb_mid, :wb_idstr, :thumbnail_pic, :posted_at, :message, :attitudes_count, :comments_count, :reposts_count

  def set_api_status(api_status)
  	self.wb_id = api_status["id"]
  	self.wb_mid = api_status["mid"]
  	self.wb_idstr = api_status["idstr"]
  	self.posted_at = api_status["created_at"]
  	self.message = api_status["text"]
  	self.attitudes_count = api_status["attitudes_count"]
  	self.comments_count = api_status["comments_count"]
  	self.reposts_count = api_status["reposts_count"]
  end
end
