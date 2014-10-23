class Event < ActiveRecord::Base

  belongs_to :user

  def formatted_date
    self.start_time.strftime('%A %d %B %Y')
  end

  def current_user_is_owner(current_user)
    self.user == current_user
  end

end
