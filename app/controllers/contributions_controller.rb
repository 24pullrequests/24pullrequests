class ContributionsController < ApplicationController
  respond_to :html, :json
  before_action :ensure_logged_in, only: [:new, :create]

  def index
    @contributions = pull_requests.page(params[:page])
    respond_with @contributions
  end

  def new
    @contribution = Contribution.new
  end

  def create
    @contribution = Contribution.new(contribution_params)
    @contribution.user_id = current_user.id
    if @contribution.save
      redirect_to @contribution
    else
      render :new
    end
  end

  def show
    @contribution = Contribution.find(params[:id])
  end

  def meta
    @pull_requests_decorator = PullRequestsDecorator.new(pull_requests)
    respond_with @pull_requests_decorator
  end

  protected

  def pull_requests
    Contribution.year(current_year).order('created_at desc').includes(:user)
  end

  def contribution_params
    params.require(:contribution).permit(:body, :repo_name, :issue_url, :created_at)
  end
end
