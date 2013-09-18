module Fetch
  def self.random_access_token
    @access_tokens = WbAccessToken.where("expires_at > ?", Time.now).all
    @access_tokens[rand(@access_tokens.size)]
  end

  def fetch_target_users(target_users)
    # need to refine
    # make the code cleaner
    target_users.each do |wb_target_user|
      wb_id = wb_target_user.wb_id
      access_token = Fetch.random_access_token
      binding.pry
      body = RestClient.get 'https://api.weibo.com/2/users/show.json', {:params => {:access_token => access_token.value, :uid => wb_id}}
      api_user = JSON(body)
      binding.pry

      wb_target_user.set_api_user(api_user)
      wb_target_user.wb_target_user_frames.create(followers_count: api_user["followers_count"], statuses_count: api_user["statuses_count"])
      wb_target_user.save!

      access_token.success_count += 1
      access_token.save!
    end
  end

  def fetch_target_user_by_id(wb_target_user)
    wb_id = wb_target_user.wb_id
    access_token = Fetch.random_access_token
    binding.pry
    body = RestClient.get 'https://api.weibo.com/2/users/show.json', {:params => {:access_token => access_token.value, :uid => wb_id}}
    api_user = JSON(body)
    binding.pry
    wb_target_user.set_api_user(api_user)
    wb_target_user.wb_target_user_frames.create(followers_count: api_user["followers_count"], statuses_count: api_user["statuses_count"])
    wb_target_user.save!

    access_token.success_count += 1
    access_token.save!
  end

  def fetch_statuses(target_users)
    target_users.each do |wb_target_user|
      wb_id = wb_target_user.wb_id
      access_token = Fetch.random_access_token
      binding.pry
      body = RestClient.get 'https://api.weibo.com/2/statuses/user_timeline.json', {:params => {:access_token => access_token.value, :uid => wb_id, :trim_user => 1, :count => 100}}
      api_statuses = JSON(body)
      binding.pry
      # api_statuses.each do |api_status|
      #   wb_status.set_api_status(api_status)
      #   wb_status.wb_status_frames.create(attitudes_count: api_status["attitudes_count"], comments_count: api_status["comments_count"], reposts_count: api_status["reposts_count"])
      #   wb_status.save!
      # end

      access_token.success_count += 1
      access_token.save!
    end
  end
end