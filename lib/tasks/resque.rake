require 'resque/tasks'

task 'resque:setup' => :environment

namespace :resque do
  task :setup do
    require 'resque'
    ENV['QUEUE'] = '*'

    Resque.redis = 'localhost:6379' unless Rails.env == 'production'
  end
end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection } #this is necessary for production environments, otherwise your background jobs will start to fail when hit from many different connections.

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"


desc "Trigger drip campaigns"
task :trigger_drip_campaigns => :environment do
  User.trigger_drip_campaigns
end