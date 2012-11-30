desc "Send daily emails"
task :send_daily_emails => :environment do
  User.where(:email_frequency => 'daily').each do |user|
    puts "** Sending daily email to #{user.email}"
    ReminderMailer.daily(user).deliver
  end
end

desc "Send weekly email"
task :send_weekly_emails => :environment do
  User.where(:email_frequency => 'weekly').each do |user|
    puts "** Sending weekly email to #{user.email}"
    ReminderMailer.weekly(user).deliver
  end
end