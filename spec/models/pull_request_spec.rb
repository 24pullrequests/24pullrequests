require 'spec_helper'

describe PullRequest do
  let(:user) { create :user }

  it { should belong_to(:user) }
  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:issue_url) }
  it { should allow_mass_assignment_of(:body) }
  it { should allow_mass_assignment_of(:state) }
  it { should allow_mass_assignment_of(:merged) }
  it { should allow_mass_assignment_of(:created_at) }
  it { should allow_mass_assignment_of(:repo_name) }
  it { should validate_uniqueness_of(:issue_url).scoped_to(:user_id) }

  describe '#create_from_github' do
    let(:json) { mock_pull_request }

    before do
      Twitter::Client.any_instance.should_receive(:update)
        .with(I18n.t 'pull_request.twitter_message', issue_url: json['payload']['pull_request']['issue_url'])
    end

    subject { user.pull_requests.create_from_github(json) }
    its(:title)      { should eq json['payload']['pull_request']['title'] }
    its(:issue_url)  { should eq json['payload']['pull_request']['issue_url'] }
    its(:created_at) { should eq json['payload']['pull_request']['created_at'] }
    its(:state)      { should eq json['payload']['pull_request']['state'] }
    its(:body)       { should eq json['payload']['pull_request']['body'] }
    its(:merged)     { should eq json['payload']['pull_request']['merged'] }
    its(:repo_name)  { should eq json['repo']['name'] }
  end
end
