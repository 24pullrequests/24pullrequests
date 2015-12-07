class ThankYouMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: '24 Pull Requests <info@24pullrequests.com>'

  def thank_you(user)
    @user = user
    mail :to         => user.email,
         :subject    => '[24 Pull Requests] Thank you for your contributions this xmas',
         'X-SMTPAPI' => '{"category": "Thank You"}'
  end
end
