class PullRequestDownloadsController < ApplicationController
  before_filter :ensure_logged_in

  def create
    current_user.download_pull_requests

    pull_requests = current_user.pull_requests.year(current_year).order('created_at desc')
    render :create, :locals => { :pull_requests => pull_requests }, :layout => false
  end
end
