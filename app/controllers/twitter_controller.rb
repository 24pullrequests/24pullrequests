class TwitterController < ApplicationController
  def authorize
    auth_hash = request.env['omniauth.auth']
    current_user.authorize_twitter!(auth_hash.info.nickname, auth_hash.credentials.token, auth_hash.credentials.secret)
    flash[:notice] = I18n.t 'twitter.account_linked'
    redirect_to :back
  end

  def remove
    current_user.remove_twitter!
    flash[:notice] = I18n.t 'twitter.account_removed'
    redirect_to :back
  end
end
