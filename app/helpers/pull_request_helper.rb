module PullRequestHelper

  def pull_request_count
    return pull_request_count_for_language if @language
    PullRequest.year(Time.now.year).count
  end

  def gift_dropdown_text pull_request
    "#{pull_request.gifted_state.to_s.humanize}: #{pull_request.repo_name} - #{pull_request.title}"
  end
end
