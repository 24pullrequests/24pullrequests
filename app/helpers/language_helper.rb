module LanguageHelper

  def pull_request_count_for_language
    PullRequest.by_language(@language).count
  end

  def user_count_for_language
    User.by_language(@language).count
  end

end
