class StaticController < ApplicationController
  def homepage
    @projects = Project.limit(200).sample(14).sort_by(&:name)
    @users = User.order('pull_requests_count desc').limit(200).sample(45)
    @pull_requests = PullRequest.year(CURRENT_YEAR).order('created_at desc').limit(5)
    @quote = Quote.random
  end

  def about
    @collaborators = User.collaborators
  end
end
