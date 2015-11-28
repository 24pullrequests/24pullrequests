class StaticController < ApplicationController
  def homepage
    @projects = Project.includes(:labels).active.limit(200).sample(6)
    @featured_projects = Project.includes(:labels).featured.limit(6)
    @users = User.order('pull_requests_count desc').limit(200).sample(24)
    @orgs = Organisation.with_user_counts.order_by_pull_requests.limit(200).sample(24)
    @pull_requests = PullRequest.year(current_year).order('created_at desc').limit(5)
  end

  def about
    @contributors = User.contributors

    # a user's location is pulled from public GitHub data
    # available on their profile when authenticating with the site
    @map_markers = Gmaps4rails.build_markers(active_users) do |user, marker|
      next if user.lat.nil? || user.lng.nil?

      marker.lat user.lat
      marker.lng user.lng
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
    PullRequest.year(current_year).map(&:user).uniq
  end
end
