class ReminderMailerPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/reminder_mailer/november
  def november
    user = User.first
    ReminderMailer.november(user)
  end

  # http://localhost:3000/rails/mailers/reminder_mailer/daily
  def daily
    user = User.first
    ReminderMailer.daily(user)
  end
end
