class TwitterController < ApplicationController
  def authorize
    auth_hash = request.env['omniauth.auth']
    current_user.authorize_twitter!(auth_hash.credentials.token, auth_hash.credentials.secret)
    flash[:notice] = I18n.t 'twitter.account_linked'
    redirect_to dashboard_path
  end
end
