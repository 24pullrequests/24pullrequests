class Contribution < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :merger, class_name: 'User', foreign_key: :merged_by_id, primary_key: :uid, optional: true
  after_save { if user then user.update_contribution_count end }
  after_destroy { if user then user.update_contribution_count end }

  validates :issue_url, uniqueness: { scope: :user_id }, if: :pull_request?
  validates_format_of :issue_url, :with => URI::regexp(), allow_blank: true

  validates :body, presence: true, length: { maximum: 300 }, unless: :pull_request?
  validates :repo_name, presence: true, unless: :pull_request?
  validates :created_at, presence: true, unless: :pull_request?
  validate :created_at_within_valid_range, unless: :pull_request?

  after_create :autogift, :post_to_firehose

  has_many :gifts

  scope :year, -> (year) { where('EXTRACT(year FROM contributions.created_at) = ?', year).where('contributions.created_at >= ?', Date.new(year, 12, 1).midnight) }
  scope :by_language, -> (language) { where('lower(language) = ?', language.downcase) }
  scope :latest, -> (limit) { order('created_at desc').limit(limit) }
  scope :valid_date_range, -> (year = Tfpullrequests::Application.current_year) {
    earliest, latest = campaign_date_bounds(year)
    where('EXTRACT(year FROM contributions.created_at) = ? AND contributions.created_at >= ? AND contributions.created_at < ?', year, earliest, latest)
  }
  scope :for_aggregation, -> {
    where(AggregationFilter.pull_request_filter)
  }
  scope :excluding_organisations, -> (excluded_organisations) {
    excluded_organisations = Array(excluded_organisations)
    where.not("repo_name ~* ?", %{^(#{excluded_organisations.join("|")})/})
  }

  EARLIEST_PULL_DATE = Date.new(Tfpullrequests::Application.current_year, 12, 1).midnight
  LATEST_PULL_DATE   = Date.new(Tfpullrequests::Application.current_year, 12, 25).midnight

  class << self
    def campaign_date_bounds(year = Tfpullrequests::Application.current_year)
      earliest = Date.new(year, 12, 1).midnight
      latest = Date.new(year, 12, 25).midnight
      [earliest, latest]
    end

    def active_users(year)
      User.where(id: Contribution.valid_date_range(year).map(&:user_id).compact.uniq)
    end

    def create_from_github(json)
      @new_contribution = create(initialize_from_github(json))
      user_time_zone = if @new_contribution.user.time_zone.nil? then 'UTC' else @new_contribution.user.time_zone end
      @new_contribution.update!(:created_at => @new_contribution.created_at.in_time_zone(user_time_zone).strftime('%Y-%m-%d %H:%M:%S'))
      @new_contribution.save
      return @new_contribution
    end

    def initialize_from_github(json)
      {
        title:      json['payload']['pull_request']['title'],
        issue_url:  json['payload']['pull_request']['_links']['html']['href'],
        created_at: json['payload']['pull_request']['created_at'],
        state:      json['payload']['pull_request']['state'],
        body:       json['payload']['pull_request']['body'],
        merged:     json['payload']['pull_request']['merged'],
        merged_by_id: (json['payload']['pull_request']['merged_by'] || {})['id'],
        repo_name:  json['repo']['name'],
        language:   json['repo']['language']
      }
    end

    def in_date_range?
      return false if ENV['DISABLED'].present?
      earliest, latest = campaign_date_bounds
      earliest <= Time.zone.now && Time.zone.now < latest
    end
  end

  def can_edit?(user)
    return false unless user.present?
    (user_id == user.id && created_at > EARLIEST_PULL_DATE) || user.admin?
  end

  def pull_request?
    state.present?
  end

  def check_state
    pr = GithubClient.new(user.nickname, user.token).pull_request(repo_name, github_id)
    update(state: pr.state,
           comments_count: pr.comments,
           merged: pr.merged,
           merged_by_id: pr.merged_by.try(:id))
  end

  def post_to_firehose
    return unless Rails.env.production?
    return unless created_at.year == Tfpullrequests::Application.current_year
    Typhoeus::Request.new(ENV['FIREHOSE_URL'],
      method: :post,
      body: self.to_json(include: { user: { only: [:uid, :nickname, :name, :blog, :location] } }),
      headers: { 'Content-Type' => 'application/json' }).run
  end

  def gifted_state
    gifts.any? ? :gifted : :not_gifted
  end

  def autogift
    return unless created_at.year == Tfpullrequests::Application.current_year
    user.new_gift(contribution: self).save if body && body.scan(/24 ?pull ?request/i).any?
  end

  private

  def github_id
    issue_url.split('/').last
  end

  def created_at_within_valid_range
    return unless created_at.present?

    campaign_year =
      if persisted? && !created_at_changed?
        created_at.year
      else
        Tfpullrequests::Application.current_year
      end
    earliest, latest = self.class.campaign_date_bounds(campaign_year)
    date_label_format = I18n.t('date.formats.long', default: '%B %d')

    unless created_at >= earliest && created_at < latest
      errors.add(
        :created_at,
        :invalid_date_range,
        earliest: I18n.l(earliest.to_date, format: date_label_format),
        latest: I18n.l((latest - 1.day).to_date, format: date_label_format)
      )
    end
  end
end
