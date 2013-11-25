class LanguageController < ApplicationController
  before_action :set_language

  def show
    @projects = Project.by_language(@language).page(params[:page])
    @users = User.by_language(@language).limit(200).sample(45)
    @pull_requests = PullRequest.by_language(@language).year(current_year).latest(5)
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
