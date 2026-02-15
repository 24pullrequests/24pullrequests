class LanguagesController < ApplicationController
  before_action :set_language

  # GET: /languages/:id
  # filters the projects, users and contributions by language
  # sets the @projects, @users and @contributions instance variable
  def show
    @projects = Project.active.by_language(@language).distinct.limit(20)
    @users = users_with_valid_date_range_counts.limit(200).sample(45)
    @contributions = Contribution.by_language(@language).valid_date_range(current_year).latest(5)
  end

  def projects
    @projects = Project.active.by_language(@language).page(params[:page])
  end

  def pull_requests
    @contributions = Contribution.by_language(@language).valid_date_range(current_year).page(params[:page])

    render 'contributions/index'
  end

  def users
    @users = users_with_valid_date_range_counts.page(params[:page])

    render 'users/index'
  end

  private

  def set_language
    @language = detect_language

    raise(ActionController::RoutingError, "#{language} is not a valid language") if @language.nil?
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

  def users_with_valid_date_range_counts
    contribution_counts_sql = Contribution
      .valid_date_range(current_year)
      .for_aggregation
      .select('contributions.user_id, COUNT(contributions.id) AS scoped_contributions_count')
      .group('contributions.user_id')
      .to_sql

    User
      .by_language(@language)
      .joins("LEFT JOIN (#{contribution_counts_sql}) scoped_contributions ON scoped_contributions.user_id = users.id")
      .select('users.*, COALESCE(scoped_contributions.scoped_contributions_count, 0) AS scoped_contributions_count')
      .order('scoped_contributions_count desc, users.nickname asc')
  end
end
