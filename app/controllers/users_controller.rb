class UsersController < ApplicationController
  before_action :ensure_logged_in, only: [:projects]

  respond_to :html, :json
  respond_to :js, only: [:index, :mergers]

  def index
    @users = User.order('pull_requests_count desc, nickname asc').page params[:page]
    respond_with @users
  end

  def show
    @user      = User.find_by_nickname!(params[:id])
    @calendar  = Calendar.new(Gift.giftable_dates(current_year), @user.gifts.year(current_year))
    @merged_pull_requests = @user.merged_pull_requests.year(current_year).latest(nil)
    respond_with @user
  end

  def projects
    @projects = current_user.projects.order('inactive desc')
  end

  def mergers
    @users = User.mergers.page params[:page]
    respond_with @users
  end
end
