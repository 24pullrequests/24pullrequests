class DashboardsController < ApplicationController
  before_filter :ensure_logged_in

  def show
    pull_requests = current_user.pull_requests
    render :show, :locals => { :user => current_user, :pull_requests => pull_requests }
  end
end
