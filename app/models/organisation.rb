class Organisation < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :pull_requests, -> { order('created_at desc').for_aggregation }, through: :users

  scope :order_by_pull_requests, -> do
    order('organisations.pull_request_count desc, organisations.login asc')
  end

  paginates_per 99

  class << self
    def create_from_github(response)
      params = {
        github_id:  response.id,
        avatar_url: response._rels[:avatar].href
      }

      where(login: response.login).first_or_create(params)
    end
  end

  def active_languages
    pull_requests.map(&:language).uniq!
  end

  def to_param
    login
  end

  def avatar_url(size = 80)
    "https://avatars.githubusercontent.com/u/#{github_id}?size=#{size}"
  end

  def update_pull_request_count
    update_attribute(:pull_request_count, pull_requests.year(CURRENT_YEAR).count)
  end
end
