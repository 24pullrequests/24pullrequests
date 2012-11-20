class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    
    pulls = PullRequest.find_by_nickname(user.nickname) rescue []
    render :show, :locals => { :user => user, :pull_requests => pulls }
  end
end
