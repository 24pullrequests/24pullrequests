class Admin::DasherController < ApplicationController
	skip_before_action :verify_authenticity_token

	before_action :check_api_key

	def new_pull_request
		user = User.find_by_nickname(params['actor']['login'])
		if user 
			user.pull_requests.create_from_github(params)
		end
		head :ok
	end

	private
	
	def check_api_key
		if ENV['API_KEY'] != params['api_key']
			render :json => { error: "Error incorrect api key" }, :status => :bad_request
		end
	end
end
