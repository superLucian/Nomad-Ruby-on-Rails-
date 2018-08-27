desc "Application reminder"
task :application_email_application_not_submitted => :environment do
  Application.send_reminder_emails
end

desc "Update SendGrid contacts"
task :update_sendgrid_contacts => :environment do
  User.update_sendgrid_contacts
end

# require 'resque/tasks'

# namespace :resque do
#   task :setup do
#     require 'resque'
#     ENV['QUEUE'] = '*'

#     Resque.redis = 'localhost:6379' unless Rails.env == 'production'
#   end
# end

# Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection } #this is necessary for production environments, otherwise your background jobs will start to fail when hit from many different connections.

# desc "Alias for resque:work (To run workers on Heroku)"
# task "jobs:work" => "resque:work"