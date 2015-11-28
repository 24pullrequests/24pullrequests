class StaticController < ApplicationController
  def homepage
    @projects = Project.includes(:labels).active.limit(200).sample(6)
    @users = User.order('pull_requests_count desc').limit(200).sample(24)
    @orgs = Organisation.with_user_counts.order_by_pull_requests.limit(200).sample(24)
    @pull_requests = PullRequest.year(current_year).order('created_at desc').limit(5)
  end

  def about
    @contributors = User.contributors
  end

  def sponsors
    @coupon = current_user.award_pullreview_coupon if current_user
  end

  def humans
    @contributors = User.contributors
  end
end
