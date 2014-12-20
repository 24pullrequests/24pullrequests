desc 'Send daily emails'
task send_emails: :environment do
  next unless PullRequest.in_date_range?

  User.all.each  do |user|
    Notification.new(user).send_email # rescue nil
  end
end

desc 'Send a november reminder to everyone'
task send_reminder: :environment do
  User.where("email <> ''").where.not(email_frequency: 'none').each do |user|
    ReminderMailer.november(user).deliver_now rescue nil
  end
end
