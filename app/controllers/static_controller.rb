class StaticController < ApplicationController
  def homepage
    redirect_to dashboard_path() if logged_in?

    @projects = Project.limit(100).sample(12)
    @users = User.limit(100).sample(45)
    @quote = Quote.random
  end
end
