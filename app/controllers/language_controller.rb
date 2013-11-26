class LanguageController < ApplicationController
  before_action :set_language, :set_js_properties

  def show
    @users = User.by_language(@language).limit(200).sample(45)
    @pull_requests = PullRequest.by_language(@language).year(current_year).latest(5)

  end

  def projects
    @projects = Project.by_language(@language).page(params[:page])

    render json: @projects
  end

  private

  def set_language
    @language = Project::LANGUAGES.select { |lan| lan.downcase.eql? language.downcase }.first

    raise ActionController::RoutingError.new("#{language} is not a valid language") if @language.nil?
  end

  def language
    params[:language]
  end

  def set_js_properties
    gon.language = language
    gon.page = params[:page] || 1
    gon.per_page = 25
    gon.project_count = Project.by_language(@language).count
  end
end

