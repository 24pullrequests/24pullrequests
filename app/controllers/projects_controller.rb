class ProjectsController < ApplicationController
  before_filter :ensure_logged_in, :except => [:index]

  def index
    @projects = Project.order(:name).all
    @current_user_languages = logged_in? ? current_user.languages : []
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      redirect_to projects_path
    else
      render :new
    end
  end
end
