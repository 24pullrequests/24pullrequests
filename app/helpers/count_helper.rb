module CountHelper
  def project_count_for_language
    Project.active.by_language(@language).count
  end

  def contribution_count_for_language
    Contribution.valid_date_range(year_for_count).by_language(@language).count
  end

  def user_count_for_language
    User.by_language(@language).count
  end

  def contribution_count
    return contribution_count_for_language if @language
    Contribution.valid_date_range(year_for_count).count
  end

  def user_count
    return user_count_for_language if @language
    User.count
  end

  private

  def year_for_count
    # Use current_year from controller if available (when called from view),
    # otherwise use the application constant (when tested in isolation)
    respond_to?(:current_year) ? current_year : Tfpullrequests::Application.current_year
  end
end
