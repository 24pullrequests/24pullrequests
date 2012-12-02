require 'spec_helper'

describe UsersController do
  describe 'GET index' do
    before do
      get :index
    end

    it { should assign_to(:users).with(User.order('pull_requests_count desc').page(0)) }
  end
end
