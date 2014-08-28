require 'spec_helper'

describe PullRequestDownloadsController, :type => :controller do

  describe "POST 'create'" do
    let(:pull_requests) { double(:pull_request, :year => double(:pull_request, :order => []))}
    let(:user) { double(:user, :id => 1, :pull_requests => pull_requests) }

    before do
      session[:user_id] = user.id
      allow(User).to receive(:find_by_id).with(user.id) { user }
    end

    it "returns http success" do
      downloader = double(:downloader)
      expect(Downloader).to receive(:new).with(user).and_return(downloader)
      expect(downloader).to receive(:get_pull_requests)

      post 'create'
      expect(response).to be_success
    end
  end

end
