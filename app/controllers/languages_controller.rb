class LanguagesController < ApplicationController
  before_action :set_language

  # GET: /languages/:id
  # filters the projects, users and contributions by language
  # sets the @projects, @users and @contributions instance variable
  def show
    @projects = Project.active.by_language(@language).distinct.limit(20)
    @users = User.order('contributions_count desc').by_language(@language).limit(200).sample(45)
    @contributions = Contribution.by_language(@language).year(current_year).latest(5)
  end

  def projects
    @projects = Project.active.by_language(@language).page(params[:page])
  end

  def pull_requests
    @contributions = Contribution.by_language(@language).year(current_year).page(params[:page])

    render 'contributions/index'
  end

  def users
    @users = User.order('contributions_count desc, nickname asc').by_language(@language).page(params[:page])

    render 'users/index'
  end

  private

  def set_language
    @language = detect_language

    fail(ActionController::RoutingError, "#{language} is not a valid language") if @language.nil?
  end

  def language
    params[:id]
  end

  def object_name
    detect_language
  end

  def detect_language
    Project::LANGUAGES.detect { |lan| lan.downcase.eql? language.downcase }
  end
end
