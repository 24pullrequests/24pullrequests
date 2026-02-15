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

  def edit
    @contribution = current_user.contributions.find_by_id(params[:id])
    redirect_to root_path, notice: t('contributions.notice.not_authorized') unless @contribution.present? && @contribution.can_edit?(current_user)
  end

  def update
    @contribution = current_user.contributions.find_by_id(params[:id])
    redirect_to root_path, notice: t('contributions.notice.not_authorized') unless @contribution.present? && @contribution.can_edit?(current_user)
    if @contribution.update(contribution_params)
      redirect_to @contribution, notice: t('contributions.notice.edit_success')
    else
      render :edit
    end
  end

  def show
    @contribution = Contribution.find(params[:id])
  end

  def destroy
    @contribution = current_user.contributions.find_by_id(params[:id])
    redirect_to root_path, notice: t('contributions.notice.not_authorized') unless @contribution.present?
    @contribution.destroy!
    redirect_back(fallback_location: root_path, notice: t('contributions.notice.destroy_success'))
  end

  def meta
    @pull_requests_decorator = PullRequestsDecorator.new(pull_requests)
    respond_with @pull_requests_decorator
  end

  protected

  def pull_requests
    Contribution.valid_date_range(current_year).order('created_at desc').includes(:user)
  end

  def contribution_params
    params.require(:contribution).permit(:body, :repo_name, :issue_url, :created_at)
  end

  def object_name
    Contribution.find_by_id(params[:id]).try(:repo_name)
  end
end
