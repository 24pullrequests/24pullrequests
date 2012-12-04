class UsersController < ApplicationController
  def index
    @users = User.order('pull_requests_count desc').page params[:page]
  end

  def show
    user = User.find_by_nickname!(params[:id])
    pull_requests = user.pull_requests.order('created_at desc')
    render :show, :locals => { :user => user, :pull_requests => pull_requests }
  end
end
