desc "Send daily emails"
task :send_emails => :environment do
  User.all.each {|u| u.send_notification_email rescue nil }
end