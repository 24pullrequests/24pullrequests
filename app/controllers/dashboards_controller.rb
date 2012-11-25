class DashboardsController < ApplicationController
  before_filter :ensure_logged_in
  before_filter :set_email_preferences, :except => [:email, :update_email]

  def show
    pull_requests = current_user.pull_requests
    render :show, :locals => { :user => current_user, :pull_requests => pull_requests }
  end

  def update_email
    if current_user.update_attributes(params[:user])
      redirect_to dashboard_path
    else
      render :email
    end
  end

  protected

  def set_email_preferences
    redirect_to email_path unless current_user.email_frequency.present?
  end
end
