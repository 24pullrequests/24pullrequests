class StaticController < ApplicationController
  def homepage
    redirect_to dashboard_path if logged_in?

    @projects = Project.limit(200).sample(14).sort_by(&:name)
    @users = User.limit(200).sample(45)
    @pull_requests = PullRequest.limit(200).sample(5)
    @quote = Quote.random
  end
end
