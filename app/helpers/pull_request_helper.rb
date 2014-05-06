module PullRequestHelper

  def pull_request_count
    return pull_request_count_for_language if @language
    PullRequest.year(CURRENT_YEAR).count
  end
end
