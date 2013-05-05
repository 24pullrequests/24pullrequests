require 'spec_helper'

describe PullRequestsController do
  describe 'GET index' do
    context 'as json' do
      before do
        create :pull_request
        get :index, :format => :json
      end

      it { response.header['Content-Type'].should include 'application/json' }
    end
  end
end
