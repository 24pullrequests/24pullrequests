class StaticController < ApplicationController
  def homepage
    @projects = Project.all.sample(6)
  end
end
