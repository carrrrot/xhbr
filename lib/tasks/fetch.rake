namespace :fetch do
  task :target_user => :environment do
    include Fetch
    $logger.info "#{Time.now} starting fetching target_user"
    fetch_target_users(WbTargetUser.where(:enabled => true).all)
  end

  task :status => :environment do
    include Fetch
    $logger.info "#{Time.now} starting fetching status"
    fetch_statuses(WbStatus.joins(:wb_target_user).where("wb_target_users.enabled" => true).readonly(false).all)
  end

  # task :aaa => :environment do
  #   include Fetch
  #   fetch_target_user_by_id(WbTargetUser.find(10))
  # end

  task :status_sentiment => :environment do
    include Fetch
    $logger.info "#{Time.now} starting fetching status_sentiment"
    fetch_statuses_sentiment(WbStatus.joins(:wb_target_user).where("wb_target_users.enabled" => true).where("sentiment is null").readonly(false).all)
  end

  task :all => ["target_user", "status", "status_sentiment"] do
  end
end
