class ConfirmationMailer < ActionMailer::Base
  default :from => "24 Pull Requests <info@24pullrequests.com>"

  def confirmation(user)
    @user = user
    mail :to => user.email,
      :subject => "[24 Pull Requests] Email Confirmation",
      'X-SMTPAPI' => '{"category": "Email Confirmation"}'
  end
end
