require 'rails_helper'

describe Contribution, type: :model do
  let(:user) { create :user }

  it { is_expected.to belong_to(:user).optional }

  describe 'pull request validations' do
    let(:json) { mock_pull_request }
    subject { user.contributions.create_from_github(json) }
    it { is_expected.to validate_uniqueness_of(:issue_url).scoped_to(:user_id) }
  end

  describe 'non-pull request validations' do
    let(:contribution) { create(:contribution, user: user, state: nil) }

    subject { contribution }
    it { validate_presence_of(:body) }
    it { validate_presence_of(:repo_name) }
    it { validate_presence_of(:created_at) }

    it 'allows valid url' do
      contribution.issue_url = "https://24pullrequests.com/"
      contribution.valid?
      expect(contribution.errors[:issue_url].count).to eq 0
    end

    it 'allows empty url' do
      contribution.issue_url = ""
      contribution.valid?
      expect(contribution.errors[:issue_url].count).to eq 0
    end

    it 'errors on invalid url' do
      contribution.issue_url = "24pullrequests.com/"
      contribution.valid?
      expect(contribution.errors[:issue_url].count).to eq 1
    end

    it 'errors on long body' do
      contribution.body = Faker::Lorem.paragraph_by_chars(number: 301)
      contribution.valid?
      expect(contribution.errors[:body].count).to eq 1
    end
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

  describe 'github body validation' do
    let(:json) { mock_pull_request }

    it 'allows long body' do
      contribution = user.contributions.create_from_github(json)
      contribution[:body] = Faker::Lorem.paragraph_by_chars(number: 301)
      contribution.valid?
      expect(contribution.errors[:body].count).to eq 0
    end
  end

  describe 'created_at dates in proper time zones' do
    let(:json) { mock_pull_request }

    context 'if the user has set a time zone' do
      let(:user) { create :user, :time_zone => 'Eastern Time (US & Canada)' }
      it 'converts the date to the set time zone' do
        contibution_json = user.contributions.create_from_github(json)
        expect(contibution_json[:created_at].strftime('%Y-%m-%d %H:%M:%S')).to eq json['payload']['pull_request']['created_at'].in_time_zone(user.time_zone).strftime('%Y-%m-%d %H:%M:%S')
      end
    end

    context 'if the user has not set a time zone' do
      it 'leaves the date as recieved from github' do
        contibution_json = user.contributions.create_from_github(json)
        expect(contibution_json[:created_at]).to eq json['payload']['pull_request']['created_at']
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

  describe '.can_edit?' do
    let(:contribution) { create :contribution }

    context 'for an admin' do
      let(:user) { mock_model(User, admin?: true) }

      it 'should return true' do
        expect(contribution.can_edit?(user)).to be true
      end
    end

    context 'when the user is not logged in' do
      it 'should return false' do
        expect(contribution.can_edit?(nil)).to be false
      end
    end

    context 'when the user is the contribution owner logged in' do
      let(:user) { mock_model(User, admin?: false) }

      it 'should return true when created in the current year' do
        contribution.user_id = user.id
        expect(contribution.can_edit?(user)).to be true
      end

      it 'should return false when created in a previous year' do
        contribution.user_id = user.id
        contribution.created_at = Faker::Date.between_except(from: 1.year.ago, to: Contribution::EARLIEST_PULL_DATE, excepted: Contribution::EARLIEST_PULL_DATE)
        expect(contribution.can_edit?(user)).to be false
      end
    end

    context 'when the user is not the contribution owner' do
      let(:user) { mock_model(User, admin?: false) }

      it 'should return false' do
        contribution.user_id = 2
        expect(contribution.can_edit?(user)).to be false
      end
    end
  end
end
