class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    render :show, :locals => { :user => user }
  end
end
