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

  def issue(repository_name, issue_id)
    client.issue(repository_name, issue_id)
  end

  def repository(repository)
    client.repo(repository)
  end

  def issues(repository, options={})
    client.issues(repository, options)
  end

  def high_rate_limit?(rate_limit=4000)
    client.rate_limit.remaining > rate_limit
  end

  private

  def client
    @client ||= Octokit::Client.new(:login => @nickname,
                                    :access_token => @token,
                                    :auto_paginate => true)
  end
end
