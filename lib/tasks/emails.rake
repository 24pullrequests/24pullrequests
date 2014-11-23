desc "Send daily emails"
task :send_emails => :environment do
  next unless PullRequest.in_date_range?

  User.all.each  do |user|
    Notification.new(user).send_email rescue nil
  end
end
