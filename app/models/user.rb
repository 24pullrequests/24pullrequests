class User < ActiveRecord::Base
  attr_accessible :uid, :provider, :nickname, :email, :gravatar_id, :token

  has_many :pull_requests

  after_create :download_pull_requests

  def self.create_from_auth_hash(hash)
    create!(extract_info(hash))
  end

  def self.find_by_auth_hash(hash)
    conditions = extract_info(hash).slice(:provider, :uid)
    where(conditions).first
  end

  def self.find(nickname)
    where(:nickname => nickname).first!
  end

  def to_param
    nickname
  end
  
  def github_client
    @github_client ||= Octokit::Client.new(:login => nickname, :oauth_token => token, :auto_traversal => true)
  end
  
  def download_pull_requests
    events = github_client.user_events(nickname)
    events.select{|e| e.type == 'PullRequestEvent' && e.payload.action == 'opened' }.map do |pr|
      unless self.pull_requests.find_by_issue_url(pr["payload"]["pull_request"]['issue_url'])
        hash = PullRequest.initialize_from_github(pr)
        p hash
        pull_request = self.pull_requests.create(hash)
      end
    end
  end

  private
  def self.extract_info(hash)
    provider    = hash.fetch('provider')
    uid         = hash.fetch('uid')
    nickname    = hash.fetch('info',{}).fetch('nickname')
    email       = hash.fetch('info',{}).fetch('email', nil)
    gravatar_id = hash.fetch('extra',{}).fetch('raw_info',{}).fetch('gravatar_id', nil)
    token       = hash.fetch('credentials', {}).fetch('token')

    {
      :provider => provider,
      :token => token,
      :uid => uid,
      :nickname => nickname,
      :email => email,
      :gravatar_id => gravatar_id
    }
  end
end
