class ReminderMailer < ActionMailer::Base

  default :from => "noreply@24pullrequests.com"

  def daily(user)
    @user = user
    mail :to => user.email,
      :subject => "[24 Pull Requests] Daily Reminder",
      'X-SMTPAPI' => '{"category": "Daily Reminder"}'
  end

  def weekly(user)
    @user = user
    mail :to => user.email,
      :subject => "[24 Pull Requests] Weekly Reminder",
      'X-SMTPAPI' => '{"category": "Weekly Reminder"}'
  end

end
