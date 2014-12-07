class PullRequest  < ActiveRecord::Base
  belongs_to :user, counter_cache: true

  validates :issue_url, unique: true, scope: :user_id

  after_create :autogift

  has_many :gifts

  scope :year, -> (year) { where('EXTRACT(year FROM "created_at") = ?', year) }
  scope :by_language, -> (language) { where('lower(language) = ?', language.downcase) }
  scope :latest, -> (limit) { order('created_at desc').limit(limit) }

  EARLIEST_PULL_DATE = Date.parse("01/12/#{CURRENT_YEAR}").midnight
  LATEST_PULL_DATE   = Date.parse("25/12/#{CURRENT_YEAR}").midnight

  class << self
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

  def post_tweet
    user.twitter.update(I18n.t 'pull_request.twitter_message', issue_url: issue_url) if user && user.twitter_linked?
  rescue => e
    Rails.logger.error "likely a Twitter API error occurred:\n"\
                       "#{e.inspect}"
  end

  def gifted_state
    gifts.any? ? :gifted : :not_gifted
  end

  def autogift
    user.new_gift(pull_request: self).save if body && body.scan(/24 ?pull ?request/i).any?
  end
end
