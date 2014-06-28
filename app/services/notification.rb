class Notification
  LESS_THAN_A_DAY = 23.hours
  LESS_THAN_A_WEEK  = 6.days + LESS_THAN_A_DAY

  def initialize(user)
    @user = user
  end

  def send_email
    return unless user.confirmed? and notifications_enabled?

    daily? ? ReminderMailer.daily(user).deliver : ReminderMailer.weekly(user).deliver
    user.update_attribute(:last_sent_at, Time.now.utc)
  end

  private

  def user
    @user
  end

  def notifications_enabled?
    daily? or weekly?
  end

  def daily?
    return false unless user.email_frequency == 'daily'

    user.last_sent_at.nil? || user.last_sent_at < LESS_THAN_A_DAY.ago
  end

  def weekly?
    return false unless  user.email_frequency == 'weekly'

    user.last_sent_at.nil? || user.last_sent_at < LESS_THAN_A_WEEK.ago
  end
end
