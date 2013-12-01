class Admin::ProjectsController < ApplicationController
  before_action :ensure_admin
  before_action :set_project, only: [ :edit, :update, :destroy ]

  respond_to :html
  respond_to :js, only: :index

  def index
    @projects = Project.order("inactive desc").order(:name).filter_by_repository(repository)

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

  def destroy
    @project.deactivate!

    redirect_to :back, notice: "#{@project.name} has been deactivated."
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
