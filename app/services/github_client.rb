class GithubClient
  def initialize(nickname, token)
    @nickname = nickname
    @token = token
  end

  def user_repository_languages
    client.repos.map(&:language).uniq.compact
  end

  def user_events
    client.user_events(@nickname)
  end

  def user_organizations
    client.organizations(@nickname)
  end

  delegate :issue, :pull_request, to: :client

  def repository(repository)
    client.repo(repository)
  end

  def labels(repository)
    client.labels(repository)
  end

  def issues(repository, options = {})
    client.issues(repository, options)
  end

  def high_rate_limit?(rate_limit = 4000)
    client.rate_limit.remaining > rate_limit
  rescue Octokit::Unauthorized, Faraday::ConnectionFailed
    true
  end

  def commits(repository, options = {})
    client.commits(repository, options)
  end

  def contributors(repository, options = {})
    Octokit.auto_paginate = true
    begin
      contributors = client.contributors(repository, options)
    rescue Octokit::Unauthorized, Octokit::RepositoryUnavailable, Faraday::ConnectionFailed
      contributors = []
    end

    Octokit.auto_paginate = false
    contributors
  end

  def organization_members(org, options = {})
    client.organization_members(org, options)
  rescue Octokit::Unauthorized, Octokit::RepositoryUnavailable, Faraday::ConnectionFailed
    []
  end

  private

  def client
    @client ||= Octokit::Client.new(login:         @nickname,
                                    access_token:  @token,
                                    auto_paginate: true)
  end
end
