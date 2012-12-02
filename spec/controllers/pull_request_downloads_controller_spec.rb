require 'spec_helper'

describe PullRequestDownloadsController do

  describe "POST 'create'" do
    let(:user) { stub(:user, id: 1, pull_requests: []) }

    before do
      session[:user_id] = user.id
      User.stub(:find_by_id).with(user.id) { user }
    end

    it "returns http success" do
      user.should_receive(:download_pull_requests)

      post 'create'
      response.should be_success
    end
  end

end
