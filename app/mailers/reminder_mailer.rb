class ReminderMailer < ActionMailer::Base

  add_template_helper(ApplicationHelper)

  FREQUENCY = { daily: "Daily", weekly: "Weekly" }

  default :from => "24 Pull Requests <info@24pullrequests.com>"

  def daily(user)
    @user = user

    mail_suggested_projects(user, FREQUENCY[:daily])
  end

  def weekly(user)
    @user = user

    mail_suggested_projects(user, FREQUENCY[:weekly])
  end

  private

  def mail_suggested_projects(user, frequency)
    @suggested_projects = user.suggested_projects.sample(8).sort_by(&:name)
    mail :to => user.email,
      :subject => %Q{[24 Pull Requests] #{frequency} Reminder},
      'X-SMTPAPI' => %Q{{"category": "#{frequency} Reminder"}}
  end
end
