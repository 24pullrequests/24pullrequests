class ProjectsController < ApplicationController
  before_action :ensure_logged_in, except: [:index]
  before_action :set_project, only: [:edit, :update, :destroy, :reactivate]

  respond_to :html
  respond_to :json, only: :index
  respond_to :js, only: [:index]

  def index
    @labels = labels
    @languages = languages
    session[:filter_options] = search_params.slice(:languages, :labels)
    search = ProjectSearch.new(search_params)
    @projects = search.call.includes(:labels)
    @has_more_projects = search.more?
    respond_with @projects
  end

  def new
    @project = Project.new
    @project.main_language = language if language
  end

  def create
    @project = current_user.projects.build(project_params)
    @project.contributing_url = @project.contrib_url(current_user.nickname, current_user.token)
    if @project.save
      redirect_to projects_path
    else
      render :new
    end
  end

  def edit
    redirect_to root_path, notice: "You can't edit this project!" unless @project.present?
  end

  def destroy
    if @project.inactive?
      @project.destroy!
      flash[:notice] = "#{@project.name} has been deleted."
    else
      @project.deactivate!
      flash[:notice] = "#{@project.name} has been deactivated."
    end
    redirect_back(fallback_location: projects_path)
  end

  def update
    if @project.update(editable_project_params)
      redirect_to projects_path(user: current_user), notice: 'Project updated successfully!'
    else
      render :edit
    end
  end

  def reactivate
    @project.reactivate!
    flash[:notice] = "#{@project.name} has been reactivated."
    redirect_back(fallback_location: projects_path)
  end

  def claim
    project = Project.find_by_github_repo(github_url)

    if project.present? && project.submitted_by.nil?
      project.update(user_id: current_user.id)
      message = "You have successfully claimed <b>#{github_url}</b>".html_safe
    else
      message = "This repository doesn't exist or belongs to someone else"
    end

    redirect_to my_suggestions_path, notice: message
  end

  def autofill
    url = params[:repo].gsub(/\/$/, '')
    request = repo_with_labels(url)
    render json: request[:data], status: request[:status]
  end

  protected

  def search_params
    { languages: languages, labels: labels, page: params[:page] }
  end

  def repo_with_labels(url)
    RepoWithLabels.new(current_user.github_client, url).call
  end

  def project_params
    params.require(:project).permit(:description, :github_url, :homepage, :name, :main_language, :contributing_url, label_ids: [])
  end

  def editable_project_params
    params.require(:project).permit(:description, :name, :main_language, label_ids: [])
  end

  def language
    params[:language]
  end

  def languages
    Array(params.fetch(:project, {}).fetch(:languages, session.fetch(:filter_options, {}).fetch(:languages, (current_user.try(:languages) || []))))
  end

  def labels
    params.fetch(:project, {}).fetch(:labels, [])
  end

  def github_url
    params[:project][:github_url]
  end

  def set_project
    @project = current_user.projects.find_by_id(params[:id])

    redirect_to user_path(current_user), notice: 'You can only edit projects you have suggested!' unless @project.present?
  end

  def objectname
    Project.find_by_id(params[:id]).try(:name)
  end
end
