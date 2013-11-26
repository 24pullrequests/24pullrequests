module PullRequestHelper

  def pull_request_count
    return pull_request_count_for_language if @language
    PullRequest.year(Time.now.year).count
  end
end
