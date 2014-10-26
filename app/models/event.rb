class Event < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :organiser, :location, :url, :start_time, :latitude, :longitude, :description
  validates :url, :format => URI::regexp(%w(http https))

  def formatted_date
    self.start_time.strftime('%A %d %B %Y at %I:%M%p')
  end

  def current_user_is_owner(current_user)
    self.user == current_user
  end

end
