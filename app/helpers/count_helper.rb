module CountHelper
  def project_count_for_language
    Project.active.by_language(@language).count
  end

  def pull_request_count_for_language
    PullRequest.year(Tfpullrequests::Application.current_year).by_language(@language).count
  end

  def user_count_for_language
    User.by_language(@language).count
  end

  def pull_request_count
    return pull_request_count_for_language if @language
    PullRequest.year(Tfpullrequests::Application.current_year).count
  end

  def user_count
    return user_count_for_language if @language
    User.count
  end
end
