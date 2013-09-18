class WbTargetUser < ActiveRecord::Base
  has_many :wb_statuses, dependent: :destroy
  has_many :wb_target_user_frames, dependent: :destroy
  accepts_nested_attributes_for :wb_target_user_frames, :wb_statuses

  def set_api_user(api_user)
    self.wb_id = api_user["id"]
  	self.name = api_user["name"]
    # self.link = "weibo.com/"+api_user["profile_url"]
    self.link = api_user["profile_url"]
    self.description = api_user["description"]
    self.profile_img_link = api_user["avatar_large"]
    self.followers_count = api_user["followers_count"]
    self.friends_count = api_user["friends_count"]
    self.statuses_count = api_user["statuses_count"]
    self.favourites_count = api_user["favourites_count"]
    self.verified = api_user["verified"]
    self.verified_reason = api_user["verified_reason"]
    self.lang = api_user["lang"]
    self.domain = api_user["domain"]
  end

  def to_param
    self.wb_id
    # (self.link =~ /\Au\/(\d*)\Z/) ? self.id : self.link
  end
end
