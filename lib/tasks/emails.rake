desc "Send daily emails"
task :send_emails => :environment do
  User.all.each {|u| u.send_notification_email rescue nil } if Time.now.utc >= Date.parse("#{CURRENT_YEAR}-12-01") && Time.now.utc < Date.parse("#{CURRENT_YEAR}-12-25")
end
