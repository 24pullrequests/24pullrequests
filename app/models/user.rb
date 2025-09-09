class User < ApplicationRecord
  attr_writer :gift_factory

  has_many :contributions,       dependent: :destroy
  has_many :skills,              dependent: :destroy
  has_many :gifts,               dependent: :destroy
  has_many :aggregation_filters, dependent: :destroy

  has_many :projects
  has_many :events

  has_and_belongs_to_many :organisations

  has_many :merged_contributions, class_name: 'Contribution', foreign_key: :merged_by_id, primary_key: :uid

  scope :by_language, ->(language) { joins(:skills).where('lower(language) = ?', language.downcase) }
  scope :with_any_contributions, -> { where('users.contributions_count > 0') }
  scope :random, -> { order(Arel.sql("RANDOM()")) }
  scope :by_nickname, ->(nickname) { where(['lower(nickname) =?', nickname.try(:downcase)]) }
  scope :active, -> { where(invalid_token: false) }

  paginates_per 96

  accepts_nested_attributes_for :skills, reject_if: proc { |attributes| !Project::LANGUAGES.include?(attributes['language']) }

  before_save :check_email_changed
  before_validation :generate_unsubscribe_token
  after_create :download_contributions, :estimate_skills, :download_user_organisations

  validates :email, presence: true, if: :send_regular_emails?
  validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, allow_blank: true, on: :update }
  validates :unsubscribe_token, presence: true, uniqueness: true

  def self.find_by_nickname!(nickname)
    by_nickname(nickname).first!
  end

  def self.find_by_nickname(nickname)
    by_nickname(nickname).first
  end

  def self.find_by_unsubscribe_token(token)
    where(unsubscribe_token: token).take
  end

  def self.find_by_login(login)
    where(['lower(nickname) =? OR lower(email) =?', login.downcase, login.downcase]).take
  end

  def self.create_from_auth_hash(hash)
    create!(AuthHash.new(hash).user_info)
  end

  def self.mergers(year = Tfpullrequests::Application.current_year)
    joins(:merged_contributions).
      where('EXTRACT(year FROM contributions.created_at) = ?', year).
      group('users.id').
      select("users.*, count(contributions.id) AS merged_contributions_count")
  end

  def assign_from_auth_hash(hash)
    # do not update the email address in case the user has updated their
    # email prefs and used a new email
    ignored_fields = %i(email name blog)
    update(AuthHash.new(hash).user_info.except(*ignored_fields))
  end

  def self.find_by_auth_hash(hash)
    conditions = AuthHash.new(hash).user_info.slice(:provider, :uid)
    where(conditions).first
  end

  def self.contributors
    @contributors ||= begin
      contribs = load_user.github_client.contributors('24pullrequests/24pullrequests')
      where_nickname_in(contribs.map(&:login))
    end
  end

  def self.admins
    @admins ||= where_nickname_in(organization_members.map(&:login))
  end

  def self.load_user
    user = User.active.order('created_at desc').limit(50).sample(1).first
    return nil unless user
    return user if user.high_rate_limit?
    load_user
  rescue Octokit::Unauthorized
    user.update(invalid_token: true)
    load_user
  end

  def self.organization_members
    load_user.github_client.organization_members('24pullrequests')
  end

  def self.where_nickname_in(nicknames)
    result = where('nickname in (?)', nicknames)
    nicknames.compact.map { |c| result.find { |u| u.nickname == c } }.compact
  end

  delegate :high_rate_limit?, to: :github_client

  def github_profile
    "https://github.com/#{nickname}" if nickname.present?
  end

  def avatar_url(size = 80)
    "https://avatars.githubusercontent.com/u/#{uid}?size=#{size}"
  end

  def suggested_projects
    Project.active.where(main_language: languages).not_owner(nickname)
  end

  def estimate_skills
    return if ENV['GITHUB_KEY'].blank?
    (Project::LANGUAGES & repo_languages).each do |language|
      skills.create(language: language)
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

  def unconfirmed?
    !confirmed? && email_frequency != 'none' && email.present?
  end

  def confirm!
    if email.present? && !confirmed?
      return update(confirmation_token: nil,
                    confirmed_at:       Time.zone.now.utc)
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

  def send_confirmation_email
    generate_confirmation_token
    save
    ConfirmationMailer.confirmation(self).deliver_now
  end

  def new_gift(attrs = {})
    GiftFactory.create!(self, gift_factory, attrs)
  end

  def gift_factory
    @gift_factory ||= Gift.public_method(:new)
  end

  def gift_for(date)
    Gift.find(id, date)
  end

  def ungifted_dates
    Gift.giftable_dates - gifts.pluck(:date)
  end

  def gift_unspent_contributions!
    return if ungifted_dates.empty?
    contributions = unspent_contributions.slice(0, ungifted_dates.count)
    contributions.each do |contribution|
      new_gift(contribution: contribution).save
    end
  end

  def send_regular_emails?
    %w(daily weekly).include?(email_frequency)
  end

  def to_param
    nickname
  end

  def download_user_organisations(access_token = token)
    orgs = Downloader.new(self, access_token).get_organisations
    orgs.each(&:update_contribution_count)
  end

  def download_contributions(access_token = token)
    Downloader.new(self, access_token).get_pull_requests
  end

  def unspent_contributions
    gifted_contributions = gifts.map(&:contribution)
    contributions_ignoring_organisations.year(Tfpullrequests::Application.current_year).reject { |pr| gifted_contributions.include?(pr) }
  end

  def needs_setup?
    email_frequency.nil?
  end

  def admin?
    @admin ||= User.admins.include?(self)
  end

  def send_thank_you_email_on_24
    return unless email.present? && contributions_count >= 24 && !thank_you_email_sent
    ThankYouMailer.thank_you(self).deliver_later
    update_column(:thank_you_email_sent, true)
  end

  def update_contribution_count
    update_column(:contributions_count, contributions.year(Tfpullrequests::Application.current_year).for_aggregation.count)
  end

  def ignored_organisations_string
    (ignored_organisations || []).join(", ")
  end

  def ignored_organisations_string= organisations_string
    self.ignored_organisations = (organisations_string || "")
      .split(",")
      .collect(&:strip)
      .compact
  end

  def contributions_ignoring_organisations
    contributions.excluding_organisations(ignored_organisations)
  end

  def unsubscribe!
    self.email_frequency = 'none'
    save
  end

  private

  def repo_languages
    @repo_languages ||= github_client.user_repository_languages
  end

  def check_email_changed
    return unless email_changed? && email.present?

    generate_confirmation_token
    self.confirmed_at = nil

    ConfirmationMailer.confirmation(self).deliver_now
  end

  def generate_unsubscribe_token
    self.unsubscribe_token ||= SecureRandom.uuid
  end
end
