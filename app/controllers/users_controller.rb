class UsersController < ApplicationController
  respond_to :html, :json
  respond_to :js, only: :index

  def index
    @users = User.order('pull_requests_count desc').includes(:pull_requests).page params[:page]
    respond_with @users
  end

  def show
    @user      = User.find_by_nickname!(params[:id])
    @calendar  = Calendar.new(Gift.giftable_dates(current_year), @user.gifts)
    respond_with @user
  end
end
