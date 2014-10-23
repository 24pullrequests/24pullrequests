class Event < ActiveRecord::Base

  def formatted_date
    self.start_time.strftime('%A %d %B %Y')
  end

end
