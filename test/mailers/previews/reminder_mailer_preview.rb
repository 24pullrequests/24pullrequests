class ReminderMailerPreview < ActionMailer::Preview

  def november
    user = User.first
    ReminderMailer.november(user)
  end

end
