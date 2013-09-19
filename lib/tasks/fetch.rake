namespace :fetch do
  task :target_user => :environment do
    include Fetch
    fetch_target_users(WbTargetUser.all)
  end

  task :status => :environment do
    include Fetch
    fetch_statuses(WbStatus.all)
  end

  task :aaa => :environment do
    include Fetch
    fetch_target_user_by_id(WbTargetUser.find(10))
  end
end
