class DashboardsController < ApplicationController
  before_filter :ensure_logged_in

  def show
    render :show, :locals => { :user => current_user }
  end
end
