require 'rails_helper'

describe Downloader do
  let(:user) { FactoryGirl.create(:user) }
  let(:downloader) { Downloader.new(user) }
  let(:gifttoday) { user.gift_for(Date.today) }

  describe '#get_organisations' do
    before do
      user_downloader = double(:user_downloader, user_organisations: [double_organisation])
      allow(downloader).to receive(:user_downloader).and_return(user_downloader)
    end

    it "creates a copy of all the user's organisations" do
      downloader.get_organisations

      expect(user.organisations.first.login).to eq('kobol')
    end
  end

  describe '#get_pull_requests' do
    let(:pull_request) { mock_pull_request }

    before do
      user_downloader = double(:user_downloader, pull_requests: [pull_request])
      allow(downloader).to receive(:user_downloader).and_return(user_downloader)
    end

    it "creates a copy of all the user's pull requests" do
      downloader.get_pull_requests

      expect(user.pull_requests.first.title).to eq(pull_request['payload']['pull_request']['title'])
    end

    it 'when the pull request does not already exist it creates it' do
      downloader.get_pull_requests

      expect(user.pull_requests.length).to eq(1)
    end

    it "when the pull request already exists it doesn't recreate it" do
      double(:user_downloader, pull_requests: [pull_request, pull_request])
      downloader.get_pull_requests

      expect(user.pull_requests.length).to eq(1)
    end

    it "when the pull request already exists it updates it" do
      old_title = pull_request['payload']['pull_request']['title']
      old_body = pull_request['payload']['pull_request']['body']
      updated_pull_request = pull_request.clone
      updated_pull_request['payload']['pull_request']['title'] += 'updated'
      updated_pull_request['payload']['pull_request']['body'] += 'updated'

      double(:user_downlaoder, pull_requests: [pull_request, updated_pull_request])
      downloader.get_pull_requests

      expect(user.pull_requests.length).to eq(1)
      expect(user.pull_requests.first.title).to eq(old_title + 'updated')
      expect(user.pull_requests.first.body).to eq(old_body + 'updated')
    end

    it "when there are no gifts for today it gifts a pull request" do
      downloader.get_pull_requests
      expect(:gifttoday).to_not be_nil
    end
  end

  def double_organisation
    double(:organisation,
           id:    2,
           _rels: { avatar: double(:avatar, href: 'href') },
           login: 'kobol')
  end
end
