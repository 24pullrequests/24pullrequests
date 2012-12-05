class PullRequest  < ActiveRecord::Base
  attr_accessible :title, :issue_url, :body, :state, :merged, :created_at, :repo_name

  belongs_to :user, counter_cache: true

  validates_uniqueness_of :issue_url, scope: :user_id

  after_create :post_tweet

  EARLIEST_PULL_DATE = Date.parse('01/12/2012').midnight
  LATEST_PULL_DATE   = Date.parse('25/12/2012').midnight

  class << self
    def create_from_github(json)
      create(initialize_from_github(json))
    end

    def initialize_from_github(json)
      {
        :title          => json['payload']['pull_request']['title'],
        :issue_url      => json['payload']['pull_request']['issue_url'],
        :created_at     => json['payload']['pull_request']['created_at'],
        :state          => json['payload']['pull_request']['state'],
        :body           => json['payload']['pull_request']['body'],
        :merged         => json['payload']['pull_request']['merged'],
        :repo_name      => json['repo']['name']
      }
    end
  end

  def post_tweet
    user.twitter.update(I18n.t 'pull_request.twitter_message', issue_url: issue_url) if user && user.twitter_linked?
  end

end
