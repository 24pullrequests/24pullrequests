class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    pull_requests = user.pull_requests
    render :show, :locals => { :user => user, :pull_requests => pull_requests }
  end
end
