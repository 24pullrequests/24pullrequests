require 'spec_helper'

describe PullRequest do
  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:issue_url) }
  it { should allow_mass_assignment_of(:body) }
  it { should allow_mass_assignment_of(:state) }
  it { should allow_mass_assignment_of(:merged) }
  it { should allow_mass_assignment_of(:created_at) }
  it { should allow_mass_assignment_of(:repo_name) }

  describe '#initialize_from_github' do
    let(:json) do
      {
        'payload' => {
          'pull_request' => {
            'title'      => Faker::Lorem.words.first,
            'issue_url'  => Faker::Internet.url,
            'created_at' => DateTime.now.to_s,
            'state'      => 'open',
            'body'       => Faker::Lorem.paragraphs.join('\n'),
            'merged'     => false
          }
        },
        'repo' => {
          'name' => Faker::Lorem.words.first
        }
      }
    end

    subject            { described_class.initialize_from_github json }
    its([:title])      { should eq json['payload']['pull_request']['title'] }
    its([:issue_url])  { should eq json['payload']['pull_request']['issue_url'] }
    its([:created_at]) { should eq json['payload']['pull_request']['created_at'] }
    its([:state])      { should eq json['payload']['pull_request']['state'] }
    its([:body])       { should eq json['payload']['pull_request']['body'] }
    its([:merged])     { should eq json['payload']['pull_request']['merged'] }
    its([:repo_name])  { should eq json['repo']['name'] }
  end
end
