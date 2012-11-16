class DashboardsController < ApplicationController
  before_filter :ensure_logged_in

  def show
    pulls = PullRequest.find_by_nickname(current_user.nickname)
    render :show, :locals => { :user => current_user, :pull_requests => pulls }
  end
end
