class Event < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :organiser, :location, :url, :start_time, :latitude, :longitude, :description
  validates :url, :format => URI::regexp(%w(http https))
  validate :validate_start_time

  def formatted_date
    self.start_time.strftime('%A %d %B %Y at %I:%M%p')
  end

  def current_user_is_owner(current_user)
    self.user == current_user
  end

  def validate_start_time
    unless (Time.parse("1st December")..Time.parse("24th December")).cover?(start_time)
      errors.add(:start_time, :not_in_range)
    end
  end

end
