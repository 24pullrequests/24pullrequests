class Event < ActiveRecord::Base

  belongs_to :user

  def formatted_date
    self.start_time.strftime('%A %d %B %Y')
  end

end
