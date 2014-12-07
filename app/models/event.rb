class Event < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :location, :url, :start_time, :latitude, :longitude, :description
  validates :url, format: URI.regexp(%w(http https))
  validate :validate_start_time_is_in_range, if: :start_time
  validate :validate_start_time_is_not_in_the_past, if: :start_time

  def formatted_date
    start_time.strftime('%A %d %B %Y at %I:%M%p')
  end

  def can_edit?(user)
    return false unless user.present?
    user_id == user.id || user.is_admin?
  end

  def validate_start_time_is_in_range
    unless (Time.parse('1st December')..Time.parse('24th December')).cover?(start_time)
      errors.add(:start_time, :not_in_range)
    end
  end

  def validate_start_time_is_not_in_the_past
    unless start_time >= Time.zone.now.beginning_of_day
      errors.add(:start_time, :in_past)
    end
  end
end
