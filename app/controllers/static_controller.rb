class StaticController < ApplicationController
  def homepage
    @projects = Project.limit(100).sample(12)
    @users = User.limit(100).sample(45)
    @quote = Quote.random
  end
end
