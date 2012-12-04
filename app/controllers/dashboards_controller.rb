class DashboardsController < ApplicationController
  before_filter :ensure_logged_in
  before_filter :set_email_preferences, :except => [:preferences, :update_preferences]

  def show
    pull_requests = current_user.pull_requests.order('created_at desc')
    projects = Project.where(:main_language => current_user.languages).limit(100).sample(12).sort_by(&:name)
    render :show, :locals => { :user => current_user, :pull_requests => pull_requests, :projects => projects }
  end

  def update_preferences
    current_user.skills.delete_all
    if current_user.update_attributes(params[:user])
      redirect_to dashboard_path
    else
      render :preferences
    end
  end

  protected

  def set_email_preferences
    redirect_to preferences_path unless current_user.email_frequency.present?
  end
end
