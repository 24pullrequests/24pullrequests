class Admin::ProjectsController < ApplicationController
  before_action :ensure_admin
  before_action :set_project, only: [ :edit, :update ]

  def index
    @projects = Project.order(:name)
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
    params.require(:project).permit(:description, :name, :main_language)
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def ensure_admin
    ensure_logged_in
    current_user.is_collaborator?
  end
end
