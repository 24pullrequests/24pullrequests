class StaticController < ApplicationController
  def homepage
    @projects = Project.includes(:labels).active.order("RANDOM()").limit(6)
    @featured_projects = Project.includes(:labels).featured.order("RANDOM()").limit(6)
    @users = User.order('pull_requests_count desc').limit(200).sample(24)
    @orgs = Organisation.order_by_pull_requests.limit(200).sample(24)
    @pull_requests = PullRequest.year(current_year).order('created_at desc').limit(5)
  end

  def about
    @contributors = User.contributors

    # a user's location is pulled from public GitHub data
    # available on their profile when authenticating with the site
    @map_markers = Rails.cache.fetch 'contributors-map-markers', expires_in: 24.hours do
      [].tap do |markers|
        active_users.each do |user, marker|
          next unless user.lat_lng

          markers << { lat: user.lat, lng: user.lng }
        end
      end
    end
  end

  def sponsors
  end

  def humans
    @contributors = User.contributors
  end

  protected

  # Currently-active contributors, i.e. users with a pull request this year
  def active_users
    PullRequest.active_users(current_year)
  end
end
