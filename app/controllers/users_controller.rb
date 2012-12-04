class UsersController < ApplicationController
  def index
    @users = User.order('pull_requests_count desc').page params[:page]
  end

  def show
    user      = User.find_by_nickname!(params[:id])
    calendar  = Calendar.new(Gift.giftable_dates, user.gifts)

    render :show, :locals => { :user => user, :calendar => calendar }
  end
end
