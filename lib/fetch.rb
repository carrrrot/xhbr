module Fetch
  def fetch_target_users(target_users)
    # need to refine
    # make the code cleaner
    target_users.each do |wb_target_user|
      wb_id = wb_target_user.wb_id
      access_token = WbAccessToken.first # need to randomize the access_token
      # client = WeiboOAuth2::Client.new
      # client.get_token_from_hash({:access_token => access_token.value, :expires_at => access_token.expires_at}) 
      # network issue !!!!!
      binding.pry
      # api_user = client.users.show_by_uid(wb_id)
      body = RestClient.get 'https://api.weibo.com/2/users/show.json', {:params => {:access_token => access_token.value, :uid => wb_id}}
      api_user = JSON(body)
      binding.pry

      # wb_target_user = WbTargetUser.new
      wb_target_user.set_api_user(api_user)
      wb_target_user.wb_target_user_frames.create(followers_count: api_user["followers_count"], statuses_count: api_user["statuses_count"])
      wb_target_user.save!
    end
  end

  def fetch_target_user_by_id(wb_target_user)
    wb_id = wb_target_user.wb_id
    access_token = WbAccessToken.first 
    binding.pry
    body = RestClient.get 'https://api.weibo.com/2/users/show.json', {:params => {:access_token => access_token.value, :uid => wb_id}}
    api_user = JSON(body)
    binding.pry
    wb_target_user.set_api_user(api_user)
    wb_target_user.wb_target_user_frames.create(followers_count: api_user["followers_count"], statuses_count: api_user["statuses_count"])
    wb_target_user.save!
  end

  def fetch_statuses(target_users)
  end
end