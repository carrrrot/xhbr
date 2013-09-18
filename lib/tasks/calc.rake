namespace :calc do
  task :followers_per_hour => :environment do
    include Calc
    calc_followers_per_hour(WbTargetUser.all)
  end
end