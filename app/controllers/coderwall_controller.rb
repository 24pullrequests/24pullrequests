class CoderwallController < ApplicationController
	def authorize
		username = params["user"]["coderwall_user_name"]
		
		begin
			coderwall_respons = ActiveSupport::JSON.decode(open("https://coderwall.com/#{username}.json").read)
		rescue Exception => e
			#show error message no user
			redirect_to :back
			return
		end
		
		if current_user.nickname == coderwall_respons["accounts"]["github"]
			current_user.coderwall_user_name = username
		else
			#show error message githubacount need to be conected with coderwall and need to be the same as on 24pullrequest
		end
		redirect_to :back
	end
end