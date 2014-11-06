class StaticController < ApplicationController
  def homepage
    @projects = Project.includes(:labels).active.limit(200).sample(14)
    @users = User.users_with_pull_request_counts(current_year).limit(200).sample(40)
    @orgs = Organisation.with_user_counts.order_by_pull_requests.limit(200).sample(40)
    @pull_requests = PullRequest.year(current_year).order('created_at desc').limit(5)
  end

  def about
    @contributors = User.contributors
  end
end
