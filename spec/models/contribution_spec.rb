require 'rails_helper'

describe Contribution, type: :model do
  let(:user) { create :user }

  it { is_expected.to belong_to(:user) }

  describe 'pull request validations' do
    let(:json) { mock_pull_request }
    subject { user.contributions.create_from_github(json) }
    it { is_expected.to validate_uniqueness_of(:issue_url).scoped_to(:user_id) }
  end

  describe 'non-pull request validations' do

    subject { build(:contribution, state: nil) }
    it { validate_presence_of(:body) }
    it { validate_presence_of(:repo_name) }
    it { validate_presence_of(:created_at) }
  end

  describe '#create_from_github' do
    let(:json) { mock_pull_request }

    subject { user.contributions.create_from_github(json) }
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
    let(:contribution) { FactoryBot.create :contribution, :user => user, :issue_url => issue_url }

    context 'if the user has authed their twitter account' do
      let(:user) { create :user, :twitter_token => 'foo', :twitter_secret => 'bar' }

      it 'tweets the pull request' do
        expect(twitter).to receive(:update).with(I18n.t 'pull_request.twitter_message', :issue_url => issue_url)
        contribution.post_tweet
      end
    end

    context 'if the user has not authed their twitter account' do
      let(:user) { create :user }

      it 'silently does not tweet the pull request' do
        expect(twitter).not_to receive(:update)
        contribution.post_tweet
      end
    end
  end

  describe '#autogift' do
    context 'when PR body contains "24 pull requests"' do
      it 'creates a gift' do
        contribution = FactoryBot.create :contribution, body: 'happy 24 pull requests!'
        expect(contribution.gifts).not_to be_empty
      end
    end

    context 'when PR body does not contain "24 pull requests"' do
      it 'does not create a gift' do
        contribution = FactoryBot.create :contribution, body: '...and a merry christmas!'
        expect(contribution.gifts).to be_empty
      end
    end
  end

  describe '#check_state' do
    let(:contribution) { create(:contribution, user: user) }
    before do
      client = double(:github_client, pull_request: Hashie::Mash.new(mock_issue))
      expect(GithubClient).to receive(:new).with(user.nickname, user.token).and_return(client)

      contribution.check_state
    end

    subject { contribution }

    its(:comments_count) { should eq 5        }
    its(:state)          { should eq 'closed' }
  end

  context '#scopes' do
    describe '.by_language' do
      let!(:contributions) { create_list(:contribution, 4, language: 'Haskell') }

      it 'returns only pull requests for the requested language' do
        expect(Contribution.by_language('Haskell').to_set).to eq contributions.to_set
      end
    end

    describe '.latest' do
      let!(:contributions) do
        4.times.map do |n|
          create(:contribution, created_at: DateTime.now + n.minutes)
        end
      end

      it 'returns the requested number of pull requests in order' do
        expect(Contribution.latest(3)).to eq(contributions.reverse.take(3))
      end
    end

    describe '.active_users' do
      it 'finds users' do
        user = create :user, nickname: 'foo'
        create(:contribution, user: user)

        expect(Contribution.active_users(Tfpullrequests::Application.current_year).map(&:nickname)).to eq(%w(foo))
      end

      it 'prevents nils' do
        nil_user = double('Contribution', user: nil)
        allow(nil_user).to receive(:user_id).and_return(nil)
        allow(Contribution).to receive(:year).and_return([nil_user, nil_user])
        expect(Contribution.active_users(Tfpullrequests::Application.current_year)).to eq([])
      end
    end

    describe '.excluding_organisations' do
      let!(:foo) { create :contribution, repo_name: "fooinc/foo" }
      let!(:bar) { create :contribution, repo_name: "barinc/bar" }
      let!(:baz) { create :contribution, repo_name: "bazinc/baz" }
      let!(:qux) { create :contribution, repo_name: "quxinc/qux" }

      it 'excludes ignored organisations' do
        expect(Contribution.excluding_organisations(%w{fooinc quxinc})).to contain_exactly(bar, baz)
      end
    end
  end
end
