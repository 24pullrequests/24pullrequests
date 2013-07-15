class DashboardsController < ApplicationController
  before_filter :ensure_logged_in
  before_filter :set_email_preferences, :except => [:preferences,
    :update_preferences]

  def show
    pull_requests = current_user.pull_requests.order('created_at desc')
    projects      = current_user.suggested_projects.limit(100).sample(
      12).sort_by(&:name)
    #NOT-USED: gifted_today  = current_user.gift_for(Time.zone.now.to_date)

    if is_december? && current_user.pull_requests.any? &&
      !current_user.gift_for(today)
       gift_form = setup_gift_form(current_user)
    end

    render :show, :locals => { :user => current_user,
                               :pull_requests => pull_requests,
                               :projects => projects,
                               :gift_form => gift_form }
  end

  def update_preferences
    current_user.skills.delete_all
    if current_user.update_attributes(params[:user])
      redirect_to dashboard_path
    else
      render :preferences
    end
  end

  def destroy
    current_user.destroy
    session.delete(:user_id)
    flash[:notice] = "Your account was successfully deleted"
    redirect_to root_path
  end

  protected

  def setup_gift_form(current_user)
    gift      = current_user.new_gift
    GiftForm.new(:gift => gift, :pull_requests =>
      current_user.unspent_pull_requests)
  end

  def today
    Time.zone.now.to_date
  end

  def is_december?
    today > Date.new(2012,12,1)
  end

  def set_email_preferences
    redirect_to preferences_path unless
      current_user.email_frequency.present?
  end
end
