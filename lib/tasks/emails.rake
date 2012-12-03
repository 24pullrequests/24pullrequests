desc "Send daily emails"
task :send_emails => :environment do
  User.all.each(&:send_notification_email)
end