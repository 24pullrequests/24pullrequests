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

    it 'allows date within valid range (December 1-24)' do
      contribution.created_at = Date.new(Tfpullrequests::Application.current_year, 12, 10)
      contribution.valid?
      expect(contribution.errors[:created_at].count).to eq 0
    end

    it 'errors on date before December 1st' do
      contribution.created_at = Date.new(Tfpullrequests::Application.current_year, 11, 30)
      contribution.valid?
      expect(contribution.errors[:created_at].count).to eq 1
    end

    it 'errors on date after December 24th' do
      contribution.created_at = Date.new(Tfpullrequests::Application.current_year, 12, 25)
      contribution.valid?
      expect(contribution.errors[:created_at].count).to eq 1
    end

    it 'errors on date in a different year' do
      contribution.created_at = Date.new(Tfpullrequests::Application.current_year - 1, 12, 10)
      contribution.valid?
      expect(contribution.errors[:created_at].count).to eq 1
    end

    it 'allows updating a historical record when created_at is unchanged' do
      historical_contribution = build(
        :contribution,
        user: user,
        state: nil,
        created_at: Date.new(Tfpullrequests::Application.current_year - 1, 12, 10)
      )
      historical_contribution.save(validate: false)

      historical_contribution.body = 'Updated body'
      historical_contribution.valid?
      expect(historical_contribution.errors[:created_at].count).to eq 0
    end

    it 'allows date on December 1st' do
      contribution.created_at = Date.new(Tfpullrequests::Application.current_year, 12, 1)
      contribution.valid?
      expect(contribution.errors[:created_at].count).to eq 0
    end

    it 'allows date on December 24th' do
      contribution.created_at = Date.new(Tfpullrequests::Application.current_year, 12, 24)
      contribution.valid?
      expect(contribution.errors[:created_at].count).to eq 0
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
        contribution_json = user.contributions.create_from_github(json)
        expect(contribution_json[:created_at].strftime('%Y-%m-%d %H:%M:%S')).to eq json['payload']['pull_request']['created_at'].in_time_zone(user.time_zone).strftime('%Y-%m-%d %H:%M:%S')
      end
    end

    context 'if the user has not set a time zone' do
      it 'leaves the date as received from github' do
        contribution_json = user.contributions.create_from_github(json)
        expect(contribution_json[:created_at]).to eq json['payload']['pull_request']['created_at']
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
    describe '.year' do
      let(:current_year) { Tfpullrequests::Application.current_year }
      let!(:dec_1_midnight) { create :contribution, created_at: Date.new(current_year, 12, 1).midnight }
      let!(:dec_2) { create :contribution, created_at: Date.new(current_year, 12, 2).midnight }
      let!(:nov_30) { create :contribution, created_at: Date.new(current_year, 11, 30).midnight }
      let!(:other_year_dec_1) { create :contribution, created_at: Date.new(current_year - 1, 12, 1).midnight }

      it 'includes contributions created at midnight on December 1st' do
        expect(Contribution.year(current_year)).to include(dec_1_midnight, dec_2)
      end

      it 'excludes contributions outside the selected year and date boundary' do
        expect(Contribution.year(current_year)).not_to include(nov_30, other_year_dec_1)
      end
    end

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
        create(:contribution, user: user, created_at: Date.new(Tfpullrequests::Application.current_year, 12, 10))

        expect(Contribution.active_users(Tfpullrequests::Application.current_year).map(&:nickname)).to eq(%w(foo))
      end

      it 'prevents nils' do
        nil_user = double('Contribution', user: nil)
        allow(nil_user).to receive(:user_id).and_return(nil)
        allow(Contribution).to receive(:valid_date_range).and_return([nil_user, nil_user])
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

    describe '.valid_date_range' do
      let!(:valid_dec_1) { create :contribution, created_at: Date.new(Tfpullrequests::Application.current_year, 12, 1) }
      let!(:valid_dec_15) { create :contribution, created_at: Date.new(Tfpullrequests::Application.current_year, 12, 15) }
      let!(:valid_dec_24) { create :contribution, created_at: Date.new(Tfpullrequests::Application.current_year, 12, 24) }
      let!(:invalid_nov_30) { create :contribution, created_at: Date.new(Tfpullrequests::Application.current_year, 11, 30) }
      let!(:invalid_dec_25) { create :contribution, created_at: Date.new(Tfpullrequests::Application.current_year, 12, 25) }
      let!(:invalid_dec_31) { create :contribution, created_at: Date.new(Tfpullrequests::Application.current_year, 12, 31) }

      it 'returns only contributions within valid date range (Dec 1-24)' do
        expect(Contribution.valid_date_range).to contain_exactly(valid_dec_1, valid_dec_15, valid_dec_24)
      end

      it 'excludes contributions before December 1st' do
        expect(Contribution.valid_date_range).not_to include(invalid_nov_30)
      end

      it 'excludes contributions on or after December 25th' do
        expect(Contribution.valid_date_range).not_to include(invalid_dec_25, invalid_dec_31)
      end

      it 'filters contributions correctly for a specified year' do
        other_year = Tfpullrequests::Application.current_year - 1

        in_range_other_year_1 = create :contribution, created_at: Date.new(other_year, 12, 5)
        in_range_other_year_2 = create :contribution, created_at: Date.new(other_year, 12, 20)

        before_range_other_year = create :contribution, created_at: Date.new(other_year, 11, 30)
        after_range_other_year = create :contribution, created_at: Date.new(other_year, 12, 25)

        results = Contribution.valid_date_range(other_year)

        expect(results).to contain_exactly(in_range_other_year_1, in_range_other_year_2)
        expect(results).not_to include(before_range_other_year, after_range_other_year, valid_dec_1)
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
