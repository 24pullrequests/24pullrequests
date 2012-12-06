class PullRequestsController < ApplicationController
  respond_to :html, :json

  def index
    @pull_requests = PullRequest.order('created_at desc').includes(:user).page params[:page]
    respond_with @pull_requests
  end
end
