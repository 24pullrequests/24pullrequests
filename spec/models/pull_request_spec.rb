require 'rails_helper'

describe PullRequest, type: :model do
  let(:user) { create :user }

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
  end

  describe ".post_tweet" do
    let(:twitter) { double(Twitter::REST::Client) }

    before do
      allow_any_instance_of(User).to receive(:twitter).and_return(twitter)
    end

    let(:issue_url) { 'http://github.com/my/issue/url' }
    let(:pull_request) { FactoryGirl.create :pull_request, :user => user, :issue_url => issue_url }

    context 'if the user has authed their twitter account' do
      let(:user) { create :user, :twitter_token => 'foo', :twitter_secret => 'bar' }

      it 'tweets the pull request' do
        expect(twitter).to receive(:update).with(I18n.t 'pull_request.twitter_message', :issue_url => issue_url)
        pull_request.post_tweet
      end
    end

    context 'if the user has not authed their twitter account' do
      let(:user) { create :user }

      it 'silently does not tweet the pull request' do
        expect(twitter).not_to receive(:update)
        pull_request.post_tweet
      end
    end
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
      it 'finds users' do
        expect(PullRequest.active_users(2015).map(&:nickname)).to eq(%w(foo))
      end

      it 'prevents nils' do
        nil_user = double('PullRequest', user: nil)
        allow(nil_user).to receive(:user_id).and_return(nil)
        allow(PullRequest).to receive(:year).and_return([nil_user, nil_user])
        expect(PullRequest.active_users(2015)).to eq([])
      end
    end
  end
end
