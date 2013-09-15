class WbTargetUserFrame < ActiveRecord::Base
  belongs_to :wb_target_user
  attr_accessible :followers_count, :statuses_count, :favourites_count, :followers_per_hour, :followers_per_hour_smoothed
end
