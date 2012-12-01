require 'spec_helper'

describe PullRequest do
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

    subject { described_class.create_from_github(json) }
    its(:title)      { should eq json['payload']['pull_request']['title'] }
    its(:issue_url)  { should eq json['payload']['pull_request']['issue_url'] }
    its(:created_at) { should eq json['payload']['pull_request']['created_at'] }
    its(:state)      { should eq json['payload']['pull_request']['state'] }
    its(:body)       { should eq json['payload']['pull_request']['body'] }
    its(:merged)     { should eq json['payload']['pull_request']['merged'] }
    its(:repo_name)  { should eq json['repo']['name'] }
  end
end
