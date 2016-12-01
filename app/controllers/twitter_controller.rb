class TwitterController < ApplicationController
  def authorize
    auth_hash = request.env['omniauth.auth']
    current_user.authorize_twitter!(auth_hash.info.nickname, auth_hash.credentials.token, auth_hash.credentials.secret)
    redirect_to user_path(current_user), notice: I18n.t('twitter.account_linked')
  end

  def remove
    current_user.remove_twitter!
    redirect_back(fallback_location: root_path, notice: I18n.t('twitter.account_removed'))
  end
end
