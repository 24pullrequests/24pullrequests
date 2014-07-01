describe Downloader do
  let(:user) { FactoryGirl.create(:user) }
  let(:downloader) { Downloader.new(user) }

  describe "#get_organisations" do
    before do
      user_downloader = double(:user_downloader, user_organisations: [double_organisation])
      downloader.stub(:user_downloader).and_return(user_downloader)
    end

    it "creates a copy of all the user's organisations" do
      downloader.get_organisations

      expect(user.organisations.first.login).to eq("kobol")
    end
  end

  def double_organisation
    double(:organisation,
           id: 2,
           _rels: { avatar: double(:avatar, href: 'href') },
           login: "kobol")
  end

  describe "#get_pull_requests" do
    let(:pull_request) { mock_pull_request }

    before do
      user_downloader = double(:user_downloader, pull_requests: [pull_request])
      downloader.stub(:user_downloader).and_return(user_downloader)
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
      user_downloader = double(:user_downloader, pull_requests: [pull_request, pull_request])
      downloader.get_pull_requests

      expect(user.pull_requests.length).to eq(1)
    end
  end

  def double_organisation
    double(:organisation,
           id: 2,
           _rels: { avatar: double(:avatar, href: 'href') },
           login: "kobol")
  end
end
