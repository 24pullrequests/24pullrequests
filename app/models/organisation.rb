class Organisation < ActiveRecord::Base
  has_and_belongs_to_many :users

  class << self
    def create_from_github(response)
      params = {
        :github_id => response.id,
        :avatar_url => response._rels[:avatar].href
      }

      where(:login => response.login).first_or_create(params)
    end
  end

  def pull_request_count
    users.map{|u| u.pull_requests_count }.reduce(:+)
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
