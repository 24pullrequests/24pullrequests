module Admin
  class DasherController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :check_api_key

    def new_pull_request
      user = User.find_by_nickname(params['actor']['login'])
      user.pull_requests.create_from_github(params) if user
      head :ok
    end

    private

    def check_api_key
      return true if ENV['API_KEY'] == params['api_key']
      render json: { error: 'Error incorrect api key' }, status: :bad_request
    end
  end
end
