desc 'Send daily emails'
task send_emails: :environment do
  next unless Contribution.in_date_range?

  User.all.find_each do |user|
    Notification.new(user).send_email # rescue nil
  end
end

desc 'Send a november reminder to everyone'
task send_reminder: :environment do
  User.where("email <> ''").where.not(email_frequency: 'none').find_each do |user|
    ReminderMailer.november(user).deliver_now rescue nil
  end
end
