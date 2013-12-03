class ProjectsController < ApplicationController
  before_action :ensure_logged_in, except: [ :index, :filter ]
  before_action :set_project, only: [ :edit, :update, :destroy ]

  respond_to :html
  respond_to :json, only: :index
  respond_to :js, only: [:index, :filter]

  def index
    @projects = Project.active.order(:name).page params[:page]
    @has_more_projects = (params[:page].to_i * 20) < Project.active.count
    @current_user_languages = logged_in? ? current_user.languages : []
    respond_with @projects
  end

  def new
    @project = Project.new
    @project.main_language = language if language
  end

  def create
    @project = current_user.projects.build(project_params)
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
    @project.deactivate!

    redirect_to :back, notice: "#{@project.name} has been deactivated."
  end

  def update
    if @project.update_attributes(editable_project_params)
      redirect_to projects_path(user: current_user), notice: "Project updated successfully!"
    else
      render :edit
    end
  end

  def claim
    project = Project.find_by_github_repo(github_url)

    if project.present? and project.submitted_by.nil?
      project.update_attribute(:user_id, current_user.id)
      message = "You have successfully claimed <b>#{github_url}</b>".html_safe
    else
      message = "This repository doesn't exist or belongs to someone else"
    end

    redirect_to :back, notice: message
  end

  def filter
    @projects = Project.active.order(:name).page params[:page]
    @projects = @projects.by_languages(languages) if languages
    respond_with @projects
  end

  protected

  def project_params
    params.require(:project).permit(:description, :github_url, :name, :main_language)
  end

  def editable_project_params
    params.require(:project).permit(:description, :name, :main_language)
  end

  def language
    params[:language]
  end

  def languages
    params[:languages].split(',')
  end

  def github_url
    params[:project][:github_url]
  end

  def set_project
    @project = current_user.projects.find_by_id(params[:id])

    redirect_to  user_path(current_user), notice: "You can only edit projects you have suggested!" unless @project.present?
  end

end
