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
end