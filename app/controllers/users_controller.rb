class UsersController < ApplicationController
  before_action :ensure_logged_in, only: [:projects]

  respond_to :html, :json
  respond_to :js, only: [:index, :mergers]

  def index
    @users = User.order('contributions_count desc, nickname asc').page params[:page]
    respond_with @users
  end

  def show
    @user      = User.find_by_nickname!(params[:id])
    giftable_dates = Gift.giftable_dates(current_year)
    user_gifts = @user.gifts.year(current_year)
    
    if giftable_dates.any? && user_gifts.any?
      @calendar = Calendar.new(giftable_dates, user_gifts)
    else
      @calendar = nil
    end
    
    @merged_contributions = @user.merged_contributions.excluding_organisations(@user.ignored_organisations).year(current_year).latest(nil)
    respond_with @user
  end

  def projects
    @projects = current_user.projects.order('inactive desc')
  end

  def mergers
    @users = User.mergers(current_year).order("merged_contributions_count DESC").page params[:page]
    respond_with @users
  end

  def unsubscribe
    @user = User.find_by_unsubscribe_token(params[:token])
    if @user
      @user.unsubscribe!
      flash[:notice] = t('unsubscribe.success')
    else
      flash[:notice] = t('unsubscribe.invalid_token')
    end
    redirect_to root_path
  end

  protected

  def object_name
    User.find_by_nickname(params[:id]).try(:nickname)
  end
end
