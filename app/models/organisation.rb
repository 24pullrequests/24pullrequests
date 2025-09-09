class Organisation < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :contributions, -> { order('created_at desc').for_aggregation }, through: :users

  scope :with_any_contributions, -> { where('organisations.contribution_count > 0') }
  scope :random, -> { order(Arel.sql("RANDOM()")) }
  scope :by_login, ->(login) { where(['lower(login) =?', login.try(:downcase)]) }
  scope :order_by_contributions, -> do
    order('organisations.contribution_count desc, organisations.login asc')
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

    def find_by_login!(login)
      by_login(login).first!
    end

    def find_by_login(login)
      by_login(login).first
    end
  end

  def active_languages
    contributions.map(&:language).uniq!
  end

  def to_param
    login
  end

  def avatar_url(size = 80)
    "https://avatars.githubusercontent.com/u/#{github_id}?size=#{size}"
  end

  def update_contribution_count
    update_column(:contribution_count, contributions.year(Tfpullrequests::Application.current_year).count)
  end
end
