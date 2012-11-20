class StaticController < ApplicationController
  def homepage
    @projects = Project.limit(100).sample(6)
    @users = User.limit(100).sample(40)
  end
end
