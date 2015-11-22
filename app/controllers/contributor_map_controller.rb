class ContributorMapController < ApplicationController
  respond_to :html, :json

  def show
    # a user's location is pulled from public GitHub data
    # available on their profile when authenticating with the site
    @map_markers = Gmaps4rails.build_markers(active_users) do |user, marker|
      next if user.lat.nil? || user.lng.nil?

      marker.lat user.lat
      marker.lng user.lng
    end

    respond_with @map_markers
  end

  protected

  # Currently-active contributors, i.e. users with a pull request this year
  def active_users
    PullRequest.year(current_year).map(&:user).uniq
  end
end
