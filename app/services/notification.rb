class Notification
  LESS_THAN_A_DAY = 23.hours
  LESS_THAN_A_WEEK = 6.days + LESS_THAN_A_DAY

  LAST_SEEN = { daily:  LESS_THAN_A_DAY,
                weekly: LESS_THAN_A_WEEK }

  def initialize(user)
    @user = user
  end

  def send_email
    return unless user.confirmed? && notifications_enabled?

    daily? ? ReminderMailer.daily(user).deliver_now : ReminderMailer.weekly(user).deliver_now
    user.update_column(:last_sent_at, Time.zone.now.utc)
  end

  private

  attr_reader :user

  def notifications_enabled?
    daily? || weekly?
  end

  def daily?
    frequency?(:daily)
  end

  def weekly?
    frequency?(:weekly)
  end

  def frequency?(frequency)
    return false unless user.email_frequency.try(:to_sym) == frequency

    user.last_sent_at.nil? || user.last_sent_at < LAST_SEEN[frequency].ago
  end
end
