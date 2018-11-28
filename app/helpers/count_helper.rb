module CountHelper
  def project_count_for_language
    Project.active.by_language(@language).count
  end

  def contribution_count_for_language
    Contribution.year(Tfpullrequests::Application.current_year).by_language(@language).count
  end

  def user_count_for_language
    User.by_language(@language).count
  end

  def contribution_count
    return contribution_count_for_language if @language
    Contribution.year(Tfpullrequests::Application.current_year).count
  end

  def user_count
    return user_count_for_language if @language
    User.count
  end
end
