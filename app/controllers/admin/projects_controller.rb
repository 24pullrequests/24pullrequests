class Admin::ProjectsController < ApplicationController
  before_action :ensure_admin
  before_action :set_project, only: [ :edit, :update ]

  respond_to :html
  respond_to :js, only: :index

  def index
    @projects = Project.order(:name).filter_by_repository(repository)

    respond_with @projects
  end

  def edit
  end

  def update
    if @project.update_attributes(editable_project_params)
      redirect_to admin_projects_path, notice: "Project updated successfully!"
    else
      render :edit
    end
  end

  protected

  def editable_project_params
    params.require(:project).permit(:description, :name, :main_language, :github_url)
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def repository
    params[:repository]
  end

  def ensure_admin
    ensure_logged_in
    current_user.is_collaborator?
  end
end
