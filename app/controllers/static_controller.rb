class StaticController < ApplicationController
  def homepage
    @projects = Project.includes(:labels).active.order(Arel.sql("RANDOM()")).limit(6)
    @featured_projects = Project.includes(:labels).featured.order(Arel.sql("RANDOM()")).limit(6)
    @users = User.with_any_contributions.random.limit(24)
    @orgs = Organisation.with_any_contributions.random.limit(24)
    @contributions = Contribution.year(current_year).order('created_at desc').limit(6)
    @mergers = User.mergers(current_year).random.page(1).per(24)
  end

  def about
    @contributors = User.contributors
  end

  def humans
    @contributors = User.contributors
  end
end
