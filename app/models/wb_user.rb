class WbUser < ActiveRecord::Base
  has_one :wb_access_token, dependent: :destroy
  accepts_nested_attributes_for :wb_access_token
end
