require 'spec_helper'

describe PullRequestDownloadsController do

  describe "POST 'create'" do
    let(:pull_requests) { double(:pull_request, :year => double(:pull_request, :order => []))}
    let(:user) { double(:user, :id => 1, :pull_requests => pull_requests) }

    before do
      session[:user_id] = user.id
      User.stub(:find_by_id).with(user.id) { user }
    end

    it "returns http success" do
      downloader = double(:downloader)
      Downloader.should_receive(:new).with(user).and_return(downloader)
      downloader.should_receive(:get_pull_requests)

      post 'create'
      response.should be_success
    end
  end

end
