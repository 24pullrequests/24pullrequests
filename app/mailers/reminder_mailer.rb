class ReminderMailer < ActionMailer::Base

  default :from => "24 Pull Requests <info@24pullrequests.com>"

  def daily(user)
    @user = user
    @suggested_projects = @user.suggested_projects.sample(8).sort_by(&:name)
    mail :to => user.email,
      :subject => "[24 Pull Requests] Daily Reminder",
      'X-SMTPAPI' => '{"category": "Daily Reminder"}'
  end

  def weekly(user)
    @user = user
    @suggested_projects = @user.suggested_projects.sample(8).sort_by(&:name)
    mail :to => user.email,
      :subject => "[24 Pull Requests] Weekly Reminder",
      'X-SMTPAPI' => '{"category": "Weekly Reminder"}'
  end

end
