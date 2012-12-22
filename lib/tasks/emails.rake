desc "Send daily emails"
task :send_emails => :environment do
  User.all.each {|u| u.send_notification_email rescue nil } if Time.now.utc < Date.parse('2012-12-25')
end
