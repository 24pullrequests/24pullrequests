require 'rails_helper'

describe PullRequest, type: :model do
  let(:user) { create :user }
  subject { create :pull_request, user: user }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_uniqueness_of(:issue_url).scoped_to(:user_id) }

  describe '#create_from_github' do
    let(:json) { mock_pull_request }

    subject { user.pull_requests.create_from_github(json) }
    its(:title)      { should eq json['payload']['pull_request']['title'] }
    its(:issue_url)  { should eq json['payload']['pull_request']['_links']['html']['href'] }
    its(:created_at) { should eq json['payload']['pull_request']['created_at'] }
    its(:state)      { should eq json['payload']['pull_request']['state'] }
    its(:body)       { should eq json['payload']['pull_request']['body'] }
    its(:merged)     { should eq json['payload']['pull_request']['merged'] }
    its(:repo_name)  { should eq json['repo']['name'] }
    its(:language)   { should eq json['repo']['language'] }

    # context 'when the user has authed their twitter account' do
    #   let(:user) { create :user, :twitter_token => 'foo', :twitter_secret => 'bar' }

    #   it 'tweets the pull request' do
    #     twitter = double('twitter')
    #     twitter.stub(:update)
    #     User.any_instance.stub(:twitter).and_return(twitter)

    #     user.twitter.should_receive(:update)
    #       .with(I18n.t 'pull_request.twitter_message', :issue_url => json['payload']['pull_request']['_links']['html']['href'])
    #     user.pull_requests.create_from_github(json)
    #   end
    # end
  end

  describe '#autogift' do
    context 'when PR body contains "24 pull requests"' do
      it 'creates a gift' do
        pull_request = FactoryGirl.create :pull_request, body: 'happy 24 pull requests!'
        expect(pull_request.gifts).not_to be_empty
      end
    end

    context 'when PR body does not contain "24 pull requests"' do
      it 'does not create a gift' do
        pull_request = FactoryGirl.create :pull_request, body: '...and a merry christmas!'
        expect(pull_request.gifts).to be_empty
      end
    end
  end

  describe '#check_state' do
    let(:pull_request) { create(:pull_request, user: user) }
    before do
      client = double(:github_client, issue: Hashie::Mash.new(mock_issue))
      expect(GithubClient).to receive(:new).with(user.nickname, user.token).and_return(client)

      pull_request.check_state
    end

    subject { pull_request }

    its(:comments_count) { should eq 5        }
    its(:state)          { should eq 'closed' }
  end

  context '#scopes' do
    let(:user) do
      create :user, nickname: 'foo'
    end

    let!(:pull_requests) do
      4.times.map  do |n|
        create(:pull_request, language:   'Haskell',
                              created_at: DateTime.now + n.minutes,
                              user: user)
      end
    end

    it 'by_language' do
      expect(PullRequest.by_language('Haskell').order('created_at asc')).to eq pull_requests
    end

    it 'latest' do
      expect(PullRequest.latest(3)).to eq(pull_requests.reverse.take(3))
    end

    describe '#active_users' do
      it 'Find users' do
        expect(PullRequest.active_users(2015).map(&:nickname)).to eq(%w(foo))
      end

      it 'Prevent nils' do
        nil_user = double('PullRequest', user: nil)
        allow(PullRequest).to receive(:year).and_return([nil_user, nil_user])
        expect(PullRequest.active_users(2015)).to eq([])
      end
    end
  end
end
