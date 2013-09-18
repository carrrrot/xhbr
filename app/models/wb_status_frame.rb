class WbStatusFrame < ActiveRecord::Base
	belongs_to :wb_status
  attr_accessible :attitudes_count, :comments_count, :reposts_count
end
