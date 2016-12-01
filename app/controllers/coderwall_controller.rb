class CoderwallController < ApplicationController
  def authorize
    username = params['user']['coderwall_username']

    begin
      coderwall_respons = ActiveSupport::JSON.decode(open("https://coderwall.com/#{username}.json").read)

      if current_user.nickname == coderwall_respons['users']['accounts']['github']
        current_user.change_coderwall_username!(username)
      else
        flash[:alert] = I18n.t 'user.coderwall.error_github_not_connected', username: username
      end
    rescue OpenURI::HTTPError, JSON::ParserError
      flash[:alert] = I18n.t 'user.coderwall.error_no_user'
    end

    flash[:notice] = I18n.t 'user.coderwall.success' if flash[:alert].nil?

    redirect_back(fallback_location: root_path)
  end
end
