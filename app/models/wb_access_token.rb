class WbAccessToken < ActiveRecord::Base
  belongs_to :wb_user
  attr_accessible :value, :expires_at
end
