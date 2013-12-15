class Organisation < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :pull_requests, -> { order("created_at desc") }, through: :users

  scope :order_by_pull_requests, -> { order("organisations.pull_request_count desc") }

  class << self
    def create_from_github(response)
      params = {
        :github_id => response.id,
        :avatar_url => response._rels[:avatar].href
      }

      where(:login => response.login).first_or_create(params)
    end
  end

  def active_languages
    pull_requests.map(&:language).uniq!
  end

  def to_param
    login
  end
end
