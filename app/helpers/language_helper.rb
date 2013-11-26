module LanguageHelper

  def project_count_for_language
    Project.by_language(@language).count
  end

  def pull_request_count_for_language
    PullRequest.year(Time.now.year).by_language(@language).count
  end

  def user_count_for_language
    User.by_language(@language).count
  end
end
