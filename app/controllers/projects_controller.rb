class ProjectsController < ApplicationController
  before_filter :ensure_logged_in, :except => [:index]
  respond_to :html
  respond_to :json, :only => :index

  def index
    @projects = Project.order(:name)
    @current_user_languages = logged_in? ? current_user.languages : []
    respond_with @projects
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to projects_path
    else
      render :new
    end
  end

  protected

  def project_params
    params.require(:project).permit(:description, :github_url, :name, :main_language)
  end
end
