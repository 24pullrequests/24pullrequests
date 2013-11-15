class UsersController < ApplicationController
  respond_to :html, :json

  def index
    @users = User.order('pull_requests_count desc').includes(:pull_requests).page params[:page]
    respond_with @users
  end

  def show
    @year      = params[:year].try(:to_i) || Time.now.year
    @user      = User.find_by_nickname!(params[:id])
    @calendar  = Calendar.new(Gift.giftable_dates(@year), @user.gifts)
    respond_with @user
  end
end
