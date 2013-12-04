class User < ActiveRecord::Base
  attr_writer :gift_factory

  has_many :pull_requests, :dependent => :destroy
  has_many :skills,        :dependent => :destroy
  has_many :gifts,         :dependent => :destroy
  has_many :projects
  has_and_belongs_to_many :organisations

  scope :by_language, -> (language) { joins(:skills).where("lower(language) = ?", language.downcase) }

  paginates_per 99

  accepts_nested_attributes_for :skills, :reject_if => proc { |attributes| !Project::LANGUAGES.include?(attributes['language']) }

  before_save :check_email_changed
  after_create :download_pull_requests, :estimate_skills, :download_user_organisations

  validates_presence_of :email, :if => :send_regular_emails?
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :allow_blank => true, :on => :update

  def self.find_by_nickname!(nickname)
    where(['lower(nickname) =?', nickname.downcase]).first!
  end

  def self.create_from_auth_hash(hash)
    create!(extract_info(hash))
  end

  def assign_from_auth_hash(hash)
    # do not update the email address in case the user has updated their
    # email prefs and used a new email
    update_attributes(self.class.extract_info(hash).except(:email))
  end

  def self.find_by_auth_hash(hash)
    conditions = extract_info(hash).slice(:provider, :uid)
    where(conditions).first
  end

  def self.collaborators
    collabs = Rails.configuration.collaborators
    return [] if collabs.nil?
    collaborators = collabs.map(&:login)
    result = where('nickname in (?)', collaborators)
    collaborators.compact.map { |c| result.find { |u| u.nickname == c } }
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

  def suggested_projects
    Project.active.where(main_language: languages).not_owner(nickname)
  end

  def estimate_skills
    if ENV['GITHUB_KEY'].present?
      languages = github_client.repos.map(&:language).uniq.compact
      (Project::LANGUAGES & languages).each do |language|
        skills.create(:language => language)
      end
    end
  end

  def languages
    skills.any? ? skills.order(:language).pluck(:language) : Project::LANGUAGES
  end

  def github_client
    @github_client ||= Octokit::Client.new(:login => nickname, :access_token => token, :auto_paginate => true)
  end

  def confirmed?
    !!confirmed_at
  end

  def confirm!
    if email.present? && !confirmed?
      self.confirmation_token = nil
      self.confirmed_at = Time.now.utc
      save
    elsif confirmed?
      errors.add(:email, :already_confirmed)
      false
    else
      errors.add(:email, :required_for_confirmation)
      false
    end
  end

  def generate_confirmation_token
    self.confirmation_token = loop do
      token = SecureRandom.urlsafe_base64
      break token unless User.where(confirmation_token: token).exists?
    end
  end

  def check_email_changed
    return unless self.email_changed?

    self.generate_confirmation_token
    self.confirmed_at = nil

    ConfirmationMailer.confirmation(self).deliver
  end

  def send_notification_email
    return unless confirmed?
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
      last_sent_at.nil? || last_sent_at < 23.hours.ago
    end
  end

  def send_weekly?
    if email_frequency == 'weekly'
      last_sent_at.nil? || last_sent_at < (6.days + 23.hours).ago
    end
  end

  def new_gift(attrs={})
    gift = gift_factory.call(attrs)
    gift.date ||= closest_free_gift_date
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

  def download_user_organisations(access_token = token)
    pull_request_downloader(access_token).user_organisations.each do |o|
      organisation = Organisation.create_from_github(o)
      organisation.users << self unless organisation.users.include?(self)
      organisation.save
    end
  end

  def download_pull_requests(access_token = token)
    pull_request_downloader(access_token).pull_requests.each do |pr|
      pull_requests.create_from_github(pr) unless pull_requests.find_by_issue_url(pr['payload']['pull_request']['_links']['html']['href'])
    end
  end

  def twitter
    @twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = twitter_token
      config.access_token_secret = twitter_secret
    end
  end

  def unspent_pull_requests
    gifted_pull_requests = gifts.map {|g| g.pull_request }
    pull_requests.reject{|pr| gifted_pull_requests.include?(pr) }
  end

  def closest_free_gift_date
    last_gift = self.gifts.last
    last_gift.nil? ? PullRequest::EARLIEST_PULL_DATE : last_gift.date + 1.day
  end

  def is_collaborator?
    @collaborator ||= User.collaborators.include?(self)
  end

  private

  def pull_request_downloader(access_token = token)
    Rails.application.config.pull_request_downloader.call(nickname, access_token)
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
