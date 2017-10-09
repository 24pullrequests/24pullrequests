require 'rails_helper'

describe PullRequestDownloadsController, type: :controller do

  describe "POST 'create'" do
    let(:pull_requests) { double(:pull_request, year: double(:pull_request, order: [])) }
    let(:user) { double(:user, id: 1, pull_requests: pull_requests) }

    before do
      session[:user_id] = user.id
      allow(User).to receive(:find_by_id).with(user.id) { user }
      allow(user).to receive(:gift_unspent_pull_requests!)
    end

    it 'returns http success' do
      downloader = double(:downloader)
      expect(Downloader).to receive(:new).with(user).and_return(downloader)
      expect(downloader).to receive(:get_pull_requests)
      expect(user).to receive(:gift_unspent_pull_requests!)
      expect(user).to receive(:send_thank_you_email_on_24)

      post 'create'
      expect(response).to be_successful
    end
  end

end
