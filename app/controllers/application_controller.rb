class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  private
  def ensure_logged_in
    unless logged_in?
      flash[:notice] = "You must be logged in to view this content."
      redirect_to root_url() # back or home might be more useful
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def logged_in?
    !!current_user
  end
end
