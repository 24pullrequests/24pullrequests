class PullRequestsController < ApplicationController
  def index
    @pull_requests = PullRequest.order('created_at desc').page params[:page]
  end
end