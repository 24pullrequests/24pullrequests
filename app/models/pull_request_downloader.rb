class PullRequestDownloader
  attr_reader :login, :oauth_token

  def initialize(login, oauth_token)
    @login, @oauth_token = login, oauth_token
  end

  def pull_requests
    @pull_requests ||= download_pull_requests
  end

  def user_organisations
    @user_organisations ||= download_user_organisations
  end

  private
  def github_client
    @github_client ||= Octokit::Client.new(:login => login, :access_token => oauth_token, :auto_paginate => true)
  end

  def download_pull_requests
    begin
      events = github_client.user_events(login)
      events.select do |e|
        event_date = e['created_at']
        e.type == 'PullRequestEvent' &&
        e.payload.action == 'opened' &&
        event_date >= PullRequest::EARLIEST_PULL_DATE &&
        event_date <= PullRequest::LATEST_PULL_DATE
      end
    rescue => e
      puts e.inspect
      puts 'Pull requests: likely a Github api error occurred'
      []
    end
  end

  def download_user_organisations
    begin
      github_client.organizations(login).reject do |o|
        puts "Updating organisation: #{o.login}"
        ignored_organisations.include?(o.login)
      end
    rescue e
      puts e.inspect
      puts 'Organisation error: likely a Github api error occurred'
      []
    end
  end

  def ignored_organisations
    [
      'coderwall-altruist',
      'coderwall-charity',
      'coderwall-kona',
      'coderwall-cub',
      'coderwall-earlyadopter',
      'coderwall-forked',
      'coderwall-komododragon',
      'coderwall-mongoose',
      'coderwall-mongoose3',
      'coderwall-octopussy',
      'coderwall-raven',
      'coderwall-polygamous'
    ]
  end

end
