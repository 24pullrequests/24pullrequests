class TwitterController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    current_user.authorize_twitter!(auth_hash.credentials.token, auth_hash.credentials.secret)
    flash[:notice] = "Your twitter account has been linked! We'll post a tweet whenever you open a pull request."
    redirect_to dashboard_path
  end
end
