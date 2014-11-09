class Notification
  LESS_THAN_A_DAY = 23.hours
  LESS_THAN_A_WEEK = 6.days + LESS_THAN_A_DAY

  LAST_SEEN = { daily: LESS_THAN_A_DAY,
                weekly: LESS_THAN_A_WEEK }

  def initialize(user)
    @user = user
  end

  def send_email
    return unless user.confirmed? and notifications_enabled?

    daily? ? ReminderMailer.daily(user).deliver : ReminderMailer.weekly(user).deliver
    user.update_attribute(:last_sent_at, Time.zone.now.utc)
  end

  private

  def user
    @user
  end

  def notifications_enabled?
    daily? or weekly?
  end

  def daily?
    is_frequency?(:daily)
  end

  def weekly?
    is_frequency?(:weekly)
  end

  private

  def is_frequency?(frequency)
    return false unless user.email_frequency.to_sym == frequency

    user.last_sent_at.nil? || user.last_sent_at < LAST_SEEN[frequency]
  end
end
