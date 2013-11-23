require 'spec_helper'

describe PullRequest do
  let(:user) { create :user }

  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:issue_url).scoped_to(:user_id) }

  describe '#create_from_github' do
    let(:json) { mock_pull_request }

    subject { user.pull_requests.create_from_github(json) }
    its(:title)      { should eq json['payload']['pull_request']['title'] }
    its(:issue_url)  { should eq json['payload']['pull_request']['issue_url'] }
    its(:created_at) { should eq json['payload']['pull_request']['created_at'] }
    its(:state)      { should eq json['payload']['pull_request']['state'] }
    its(:body)       { should eq json['payload']['pull_request']['body'] }
    its(:merged)     { should eq json['payload']['pull_request']['merged'] }
    its(:repo_name)  { should eq json['repo']['name'] }

    context 'when the user has authed their twitter account' do
      let(:user) { create :user, :twitter_token => 'foo', :twitter_secret => 'bar' }

      it 'tweets the pull request' do
        Twitter::Client.any_instance.should_receive(:update)
          .with(I18n.t 'pull_request.twitter_message', :issue_url => json['payload']['pull_request']['issue_url'])
        user.pull_requests.create_from_github(json)
      end
    end
  end

  describe '#autogift' do
    context 'when PR body contains "24 pull requests"' do
      it 'creates a gift' do
        pull_request = FactoryGirl.create :pull_request, body: 'happy 24 pull requests!'
        pull_request.gifts.should_not be_empty
      end
    end

    context 'when PR body does not contain "24 pull requests"' do
      it 'does not create a gift' do
        pull_request = FactoryGirl.create :pull_request, body: "...and a merry christmas!"
        pull_request.gifts.should be_empty
      end
    end
  end
end
