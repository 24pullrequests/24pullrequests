class UsersController < ApplicationController
  respond_to :html, :json

  def index
    @users = User.order('pull_requests_count desc').includes(:pull_requests).page params[:page]
    respond_with @users
  end

  def show
    @user      = User.find_by_nickname!(params[:id])
    @calendar  = Calendar.new(Gift.giftable_dates, @user.gifts)
    respond_with @user
  end

  def destroy
    current_user.delete
    flash[:notice] = "Your account was successfully deleted."
    redirect_to root_path
  end
end
