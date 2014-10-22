class User < ActiveRecord::Base
  include Concerns::Coderwall
  include Concerns::Twitter

  attr_writer :gift_factory

  has_many :pull_requests, :dependent => :destroy
  has_many :skills,        :dependent => :destroy
  has_many :gifts,         :dependent => :destroy
  has_many :projects
  has_and_belongs_to_many :organisations

  has_many :archived_pull_requests

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
    create!(AuthHash.new(hash).user_info)
  end

  def assign_from_auth_hash(hash)
    # do not update the email address in case the user has updated their
    # email prefs and used a new email
    update_attributes(AuthHash.new(hash).user_info.except(:email))
  end

  def self.find_by_auth_hash(hash)
    conditions = AuthHash.new(hash).user_info.slice(:provider, :uid)
    where(conditions).first
  end

  def self.contributors
    contribs = Rails.configuration.contributors.map(&:login)

    where_nickname_in(contribs)
  end

  def self.admins
    org_members = Rails.configuration.organization_members.map(&:login)

    where_nickname_in(org_members)
  end

  def self.where_nickname_in(nicknames)
    result = where('nickname in (?)', nicknames)
    nicknames.compact.map { |c| result.find { |u| u.nickname == c } }.compact
  end

  def github_profile
    "https://github.com/#{nickname}" if nickname.present?
  end

  def suggested_projects
    Project.active.where(main_language: languages).not_owner(nickname)
  end

  def estimate_skills
    if ENV['GITHUB_KEY'].present?
      (Project::LANGUAGES & repo_languages).each do |language|
        skills.create(:language => language)
      end
    end
  end

  def languages
    skills.any? ? skills.order(:language).pluck(:language) : Project::LANGUAGES
  end

  def github_client
    @github_client ||= GithubClient.new(nickname, token)
  end

  def confirmed?
    !!confirmed_at
  end

  def confirm!
    if email.present? && !confirmed?
      return update_attributes(confirmation_token: nil, confirmed_at: Time.now.utc)
    elsif confirmed?
      errors.add(:email, :already_confirmed)
    else
      errors.add(:email, :required_for_confirmation)
    end
    false
  end

  def generate_confirmation_token
    self.confirmation_token = loop do
      token = SecureRandom.urlsafe_base64
      break token unless User.where(confirmation_token: token).exists?
    end
  end

  def new_gift(attrs={})
    GiftFactory.create!(self, gift_factory, attrs)
  end

  def gift_factory
    @gift_factory ||= Gift.public_method(:new)
  end

  def gift_for(date)
    Gift.find(id, date)
  end

  def send_regular_emails?
    ['daily', 'weekly'].include?(email_frequency)
  end

  def to_param
    nickname
  end

  def download_user_organisations(access_token = token)
    Downloader.new(self, access_token).get_organisations
  end

  def download_pull_requests(access_token = token)
    Downloader.new(self, access_token).get_pull_requests
  end

  def unspent_pull_requests
    gifted_pull_requests = gifts.map {|g| g.pull_request }
    pull_requests.reject{|pr| gifted_pull_requests.include?(pr) }
  end

  def is_admin?
    @admin ||= User.admins.include?(self)
  end

  def self.users_with_pull_request_counts pull_request_year
    joins(:pull_requests).where('EXTRACT(year FROM pull_requests.created_at) = ?', pull_request_year).select("users.*, COUNT(pull_requests.id) as pull_requests_count").group("users.id")
  end

  private

  def repo_languages
    @repo_languages ||= github_client.user_repository_languages
  end

  def check_email_changed
    return unless self.email_changed? && self.email.present?

    self.generate_confirmation_token
    self.confirmed_at = nil

    ConfirmationMailer.confirmation(self).deliver
  end
end
