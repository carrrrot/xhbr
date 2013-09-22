module Fetch
  def self.random_access_token
    @access_tokens = WbAccessToken.where("expires_at > ?", Time.now).all
    @access_tokens[rand(@access_tokens.size)]
  end

  NET_ISSUE = "getaddrinfo: nodename nor servname provided, or not known"

  def fetch_target_users(target_users)
    # need to refine
    # make the code cleaner
    target_users.each do |wb_target_user|
      retry_time = 0
      begin
        wb_id = wb_target_user.wb_id
        access_token = Fetch.random_access_token
        body = RestClient.get 'https://api.weibo.com/2/users/show.json', {:params => {:access_token => access_token.value, :uid => wb_id}}
        api_user = JSON(body)

        wb_target_user.set_api_user(api_user)
        wb_target_user.wb_target_user_frames.create(followers_count: api_user["followers_count"], statuses_count: api_user["statuses_count"])
        if !wb_target_user.wb_statuses.exists?(:wb_mid => api_user["status"]["mid"])
          api_status = api_user["status"]
          wb_target_user.wb_statuses.create(
            wb_id: api_status["id"],
            wb_mid: api_status["mid"], 
            wb_idstr: api_status["idstr"], 
            posted_at: api_status["created_at"], 
            message: api_status["text"],
            attitudes_count: api_status["attitudes_count"],
            comments_count: api_status["comments_count"],
            reposts_count: api_status["reposts_count"])
        end
        wb_target_user.save!

        access_token.success_count += 1
      rescue
        # $logger.error "#{Time.now} fetch_target_users error: #{$!} at: #{$@}"
        if retry_time < 10 and $!.to_s == NET_ISSUE
          $logger.error "#{Time.now} fetch_target_users error: #{$!}. retried for #{retry_time} times."
          retry_time += 1
          retry
        else
          $logger.error "#{Time.now} fetch_target_users error: #{$!}."
          access_token.error_count += 1
        end
      ensure
        access_token.save!
      end
    end
  end

  # def fetch_target_user_by_id(wb_target_user)
  #   wb_id = wb_target_user.wb_id
  #   access_token = Fetch.random_access_token
  #   binding.pry
  #   body = RestClient.get 'https://api.weibo.com/2/users/show.json', {:params => {:access_token => access_token.value, :uid => wb_id}}
  #   api_user = JSON(body)
  #   binding.pry
  #   wb_target_user.set_api_user(api_user)
  #   wb_target_user.wb_target_user_frames.create(followers_count: api_user["followers_count"], statuses_count: api_user["statuses_count"])
  #   wb_target_user.save!

  #   access_token.success_count += 1
  #   access_token.save!
  # end

  def fetch_statuses(statuses)
    statuses.each do |status|
      retry_time = 0
      begin
        wb_id = status.wb_id
        access_token = Fetch.random_access_token
        body = RestClient.get 'https://api.weibo.com/2/statuses/show.json', {:params => {:access_token => access_token.value, :id => wb_id}}
        api_status = JSON(body)
        status.set_api_status(api_status)
        status.wb_status_frames.create(attitudes_count: api_status["attitudes_count"], comments_count: api_status["comments_count"], reposts_count: api_status["reposts_count"])
        status.save!
        access_token.success_count += 1
      rescue
        if retry_time < 10 and $!.to_s == NET_ISSUE
          $logger.error "#{Time.now} fetch_statuses error: #{$!}. retried for #{retry_time} times."
          retry_time += 1
          retry
        else
          $logger.error "#{Time.now} fetch_statuses error: #{$!}."
          access_token.error_count += 1
        end
      ensure
        access_token.save!
      end
    end
  end

  def fetch_statuses_sentiment(statuses)
    # cannot use bulk_sentiment because of all the sentiment score will be 1
    repustate = Repustate.new(REPUSTATE_API_KEY)
    statuses.each do |status|
      retry_time = 0
      begin
        body = repustate.sentiment(:text => status.message, :lang => 'zh')
        status.sentiment = body["score"] if body["status"]=="OK"
        status.save!
      rescue
        if retry_time < 10 and $!.to_s == NET_ISSUE
          $logger.error "#{Time.now} fetch_statuses_sentiment error: #{$!}. retried for #{retry_time} times."
          retry_time += 1
          retry
        else
          $logger.error "#{Time.now} fetch_statuses_sentiment error: #{$!}."
        end
      end
    end
  end
  
end