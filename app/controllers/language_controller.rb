class LanguageController < ApplicationController

  def show
    @projects = Project.by_language(language).limit(200).sample(14).sort_by(&:name)
    @users = User.by_language(language).limit(200).sample(45)
    @pull_requests = PullRequest.by_language(language).year(current_year).order('created_at desc').limit(5)

    @language = Project::LANGUAGES.select { |lan| lan.downcase.eql? language.downcase }.first
  end

  private

  def language
    params[:language]
  end
end
