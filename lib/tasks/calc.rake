namespace :calc do
  task :followers_per_hour => :environment do
    include Calc
    $logger.info "#{Time.now} calculating followers_per_hour"
    calc_followers_per_hour(WbTargetUser.where(:enabled => true).all)
  end

  task :all => ["followers_per_hour"] do
  end
end