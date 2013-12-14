class Organisation < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :pull_requests, through: :users

  paginates_per 99

  scope :order_by_pull_requests, -> { with_pull_request_count.order("pull_request_count desc") }

  scope :with_pull_request_count, -> {
    select("organisations.*, count(pull_requests.user_id) as pull_request_count").
    group("organisations.id").
    joins(:users).
    joins("LEFT OUTER join pull_requests on pull_requests.user_id = users.id ")
  }

  class << self
    def create_from_github(response)
      params = {
        :github_id => response.id,
        :avatar_url => response._rels[:avatar].href
      }

      where(:login => response.login).first_or_create(params)
    end
  end

  def pull_requests
    @pull_requests ||= users.map { |u| u.pull_requests.year(2013) }.flatten.sort_by(&:created_at).reverse
  end

  def active_languages
    pull_requests.map(&:language).uniq!
  end

  def to_param
    self.login
  end
end
