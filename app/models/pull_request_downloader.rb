class PullRequestDownloader
  attr_reader :login, :oauth_token

  def initialize(login, oauth_token)
    @login = login
    @oauth_token = oauth_token
  end

  def pull_requests
    @pull_requests ||= download_pull_requests
  end

  def user_organisations
    @user_organisations ||= download_user_organisations
  end

  private

  def github_client
    @github_client ||= GithubClient.new(login, oauth_token)
  end

  def download_pull_requests
    github_client.user_events.select do |e|
      event_date = e['created_at']
      e.type == 'PullRequestEvent' &&
        e.payload.action == 'opened' &&
        event_date >= PullRequest::EARLIEST_PULL_DATE &&
        event_date <= PullRequest::LATEST_PULL_DATE
    end
  rescue => e
    Rails.logger.error "Pull requests: likely a GitHub API error occurred:\n"\
                       "#{e.inspect}"
    []
  end

  def download_user_organisations
    github_client.user_organizations.reject do |o|
      Rails.logger.info "Updating organisation: #{o.login}"
      o.login.match(/^coderwall-/)
    end
  rescue => e
    Rails.logger.error "Organisation error: likely a GitHub API error occurred:\n"\
                       "#{e.inspect}"
    []
  end
end
