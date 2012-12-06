class User < ActiveRecord::Base
  attr_accessible :uid, :provider, :nickname, :email, :gravatar_id, :token, :email_frequency, :skills_attributes, :twitter_token

  attr_writer :gift_factory

  has_many :pull_requests
  has_many :skills
  has_many :gifts

  paginates_per 99

  accepts_nested_attributes_for :skills, :reject_if => proc { |attributes| !Project::LANGUAGES.include?(attributes['language']) }

  after_create :download_pull_requests

  validates_presence_of :email, :if => :send_regular_emails?

  def self.find_by_nickname!(nickname)
    where(['lower(nickname) =?', nickname.downcase]).first!
  end

  def self.create_from_auth_hash(hash)
    create!(extract_info(hash))
  end

  def self.find_by_auth_hash(hash)
    conditions = extract_info(hash).slice(:provider, :uid)
    where(conditions).first
  end

  def self.collaborators
    collaborators = Rails.configuration.collaborators.map(&:login)
    where('nickname in (?)', collaborators)
  end

  def authorize_twitter!(nickname, token, secret)
    self.twitter_nickname = nickname
    self.twitter_token    = token
    self.twitter_secret   = secret
    self.save!
  end

  def remove_twitter!
    self.twitter_nickname = nil
    self.twitter_token    = nil
    self.twitter_secret   = nil
    self.save!
  end

  def twitter_linked?
    twitter_token.present? && twitter_secret.present?
  end

  def twitter_profile
    "https://twitter.com/#{twitter_nickname}" if twitter_nickname.present?
  end

  def github_profile
    "https://github.com/#{nickname}" if nickname.present?
  end

  def estimate_skills
    languages = github_client.repos.map(&:language).uniq.compact
    (Project::LANGUAGES & languages).each do |language|
      skills.create(:language => language)
    end
  end

  def languages
    skills.any? ? skills.order(:language).map(&:language) : Project::LANGUAGES
  end

  def github_client
    @github_client ||= Octokit::Client.new(:login => nickname, :oauth_token => token, :auto_traversal => true)
  end

  def send_notification_email
    if send_daily?
      ReminderMailer.daily(self).deliver
    elsif send_weekly?
      ReminderMailer.weekly(self).deliver
    else
      return
    end
    update_attribute(:last_sent_at, Time.now.utc)
  end

  def send_daily?
    if email_frequency == 'daily'
      last_sent_at.nil? || last_sent_at < 1.day.ago
    end
  end

  def send_weekly?
    if email_frequency == 'weekly'
      last_sent_at.nil? || last_sent_at < 7.days.ago
    end
  end

  def new_gift(attrs={})
    gift = gift_factory.call(attrs)
    gift.user = self
    gift
  end

  def gift_for(date)
    Gift.find(id, date)
  end

  def send_regular_emails?
    ['daily', 'weekly'].include? email_frequency
  end

  def to_param
    nickname
  end

  def download_pull_requests
    pull_request_downloader.pull_requests.each do |pr|
      pull_requests.create_from_github(pr) unless pull_requests.find_by_issue_url(pr['payload']['pull_request']['issue_url'])
    end
  end

  def twitter
    @twitter ||= Twitter::Client.new(
      consumer_key: ENV['TWITTER_KEY'],
      consumer_secret: ENV['TWITTER_SECRET'],
      oauth_token: twitter_token,
      oauth_token_secret: twitter_secret
    )
  end

  private
  def pull_request_downloader
    Rails.application.config.pull_request_downloader.call(nickname, token)
  end

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

  def gift_factory
    @gift_factory ||= Gift.public_method(:new)
  end
end
