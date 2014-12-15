class PullRequestsController < ApplicationController
  respond_to :html, :json

  def index
    @pull_requests = pull_requests.page(params[:page])
    respond_with @pull_requests
  end

  def meta
    @pull_requests_decorator = PullRequestsDecorator.new(pull_requests)
    respond_with @pull_requests_decorator
  end

  protected
  def pull_requests
    PullRequest.year(current_year).order('created_at desc').includes(:user)
  end
end
