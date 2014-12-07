module UserHelper
  def user_count
    return user_count_for_language if @language
    User.count
  end
end
