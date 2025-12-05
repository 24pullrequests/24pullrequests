class SessionsController < ApplicationController
  unless Rails.env.production?
    skip_before_action :verify_authenticity_token, only: [:create]
  end

  def new
    render :new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    user      = User.find_by_auth_hash(auth_hash) || User.new

    user.assign_from_auth_hash(auth_hash)

    flash[:notice] = nil
    session[:user_id] = user.id

    redirect_to(dashboard_url) && return unless pre_login_destination
    redirect_to pre_login_destination
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end

  def failure
    redirect_to(root_path, notice: I18n.t('twitter.auth_failed'))
  end

  private

  def pre_login_destination
    session[:pre_login_destination]
  end
end
