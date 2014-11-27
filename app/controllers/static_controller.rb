class StaticController < ApplicationController
  def homepage
    @projects = Project.includes(:labels).active.limit(200).sample(14)
    @users = User.order('pull_requests_count desc').includes(:pull_requests).limit(200).sample(40)
    @orgs = Organisation.with_user_counts.order_by_pull_requests.limit(200).sample(40)
    @pull_requests = PullRequest.year(current_year).order('created_at desc').limit(5)

    render layout: "homepage"
  end

  def about
    @contributors = User.contributors
  end

  def humans
    @contributors = Rails.env.production? ? load_contributors : []
    render "static/humans.txt.erb", content_type: "text/plain"
  end

  private

  def load_contributors
    Rails.application.config.contributors.map(&:login).map do |login|
      next if login.eql?("andrew")
      Octokit.user(login)
    end.compact
  end
end
