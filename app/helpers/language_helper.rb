module LanguageHelper

  def project_count_for_language
    Project.active.by_language(@language).count
  end

  def pull_request_count_for_language
    PullRequest.year(CURRENT_YEAR).by_language(@language).count
  end

  def user_count_for_language
    User.by_language(@language).count
  end
end
