module Admin
  class ProjectsController < ApplicationController
    before_action :ensure_logged_in
    before_action :ensure_admin
    before_action :set_project, only: [:edit, :update, :destroy]

    respond_to :html
    respond_to :js, only: :index

    def index
      @projects = Project.order('inactive desc').order(:name).filter_by_repository(repository).page params[:page]

      respond_with @projects
    end

    def edit
    end

    def update
      if @project.update(editable_project_params)
        redirect_to admin_projects_path, notice: 'Project updated successfully!'
      else
        render :edit
      end
    end

    def destroy
      @project.deactivate!

      redirect_back(fallback_location: admin_projects_path, notice: "#{@project.name} has been deactivated.")
    end

    protected

    def editable_project_params
      params.require(:project).permit(:description, :name, :main_language, :github_url, :homepage, :featured)
    end

    def set_project
      @project = Project.find(params[:id])
    end

    def repository
      params[:repository]
    end

    def ensure_admin
      current_user.admin?
    end
  end
end
