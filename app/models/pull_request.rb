class PullRequest < ActiveRecord::Base
  belongs_to :user, counter_cache: true

  validates :issue_url, uniqueness: { scope: :user_id }

  after_create :autogift, :post_to_firehose

  has_many :gifts

  scope :year, -> (year) { where('EXTRACT(year FROM "created_at") = ?', year) }
  scope :by_language, -> (language) { where('lower(language) = ?', language.downcase) }
  scope :latest, -> (limit) { order('created_at desc').limit(limit) }
  scope :for_aggregation, -> {
    where(AggregationFilter::PULL_REQUEST_SQL_FILTER)
  }

  EARLIEST_PULL_DATE = Date.parse("01/12/#{CURRENT_YEAR}").midnight
  LATEST_PULL_DATE   = Date.parse("25/12/#{CURRENT_YEAR}").midnight

  class << self
    def active_users(year)
      PullRequest.includes(:user).year(year).map(&:user).uniq.compact
    end

    def create_from_github(json)
      create(initialize_from_github(json))
    end

    def initialize_from_github(json)
      {
        title:      json['payload']['pull_request']['title'],
        issue_url:  json['payload']['pull_request']['_links']['html']['href'],
        created_at: json['payload']['pull_request']['created_at'],
        state:      json['payload']['pull_request']['state'],
        body:       json['payload']['pull_request']['body'],
        merged:     json['payload']['pull_request']['merged'],
        repo_name:  json['repo']['name'],
        language:   json['repo']['language']
      }
    end

    def in_date_range?
      EARLIEST_PULL_DATE < Time.zone.now && Time.zone.now < LATEST_PULL_DATE
    end
  end

  def check_state
    issue = GithubClient.new(user.nickname, user.token).issue(repo_name, id)
    update_attributes(state: issue.state, comments_count: issue.comments)
  end

  def post_to_firehose
    return unless Rails.env.production?
    Typhoeus::Request.new(ENV['FIREHOSE_URL'],
      method: :post,
      body: self.to_json(include: { user: { only: [:uid, :nickname, :name, :blog, :location] } }),
      headers: { 'Content-Type' => 'application/json' }).run
  end

  def post_tweet
    user.twitter.update(I18n.t 'pull_request.twitter_message', issue_url: issue_url) if user && user.twitter_linked?
  rescue => e
    Rails.logger.error "likely a Twitter API error occurred:\n"\
                       "#{e.inspect}"
  end

  def gifted_state
    gifts.any? ? :gifted : :not_gifted
  end

  def update_user_pr_count
    user.update_pr_count
  end

  def autogift
    user.new_gift(pull_request: self).save if body && body.scan(/24 ?pull ?request/i).any?
  end
end
