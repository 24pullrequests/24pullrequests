class ProjectsController < ApplicationController
  before_action :ensure_logged_in, except: [ :index ]
  before_action :set_project, only: [ :edit, :update ]

  respond_to :html
  respond_to :json, :only => :index

  def index
    @projects = Project.order(:name)
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

  def update
    if @project.update_attributes(editable_project_params)
      redirect_to projects_path(user: current_user), notice: "Project updated successfully!"
    else
      render :edit
    end
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

  def set_project
    @project = current_user.projects.find_by_id(params[:id])

    redirect_to  user_path(current_user), notice: "You can only edit projects you have suggested!" unless @project.present?
  end

end
