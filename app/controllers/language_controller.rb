class LanguageController < ApplicationController
  before_action :set_language

  def show
    @projects = Project.by_language(@language).limit(20)
    @users = User.by_language(@language).limit(200).sample(45)
    @pull_requests = PullRequest.by_language(@language).year(current_year).latest(5)
  end

  def projects
    @projects = Project.by_language(@language).page(params[:page])
  end

  def pull_requests
    @pull_requests = PullRequest.by_language(@language).year(current_year).page(params[:page])
  end

  def users
    @users = User.by_language(@language).page(params[:page])

    render 'users/index'
  end

  private

  def set_language
    @language = Project::LANGUAGES.select { |lan| lan.downcase.eql? language.downcase }.first

    raise ActionController::RoutingError.new("#{language} is not a valid language") if @language.nil?
  end

  def language
    params[:language]
  end
end
