class StaticController < ApplicationController
  def homepage
    @projects = Project.active.limit(200).sample(14)
    @users = User.users_with_pull_request_counts(current_year).limit(200).sample(45)
    @pull_requests = PullRequest.year(current_year).order('created_at desc').limit(5)
    @quote = Quote.random
  end

  def about
    @collaborators = User.collaborators
  end
end
