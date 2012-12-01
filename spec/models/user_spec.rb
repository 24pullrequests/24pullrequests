require 'spec_helper'

describe User do
  let(:user) { create :user }

  it { should allow_mass_assignment_of(:uid) }
  it { should allow_mass_assignment_of(:provider) }
  it { should allow_mass_assignment_of(:nickname) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:gravatar_id) }
  it { should allow_mass_assignment_of(:token) }
  it { should allow_mass_assignment_of(:email_frequency) }
  it { should allow_mass_assignment_of(:skills_attributes) }

  it { should have_many(:pull_requests) }
  it { should have_many(:skills) }

  it { should accept_nested_attributes_for(:skills) }

  %w[daily weekly].each do |frequency|
    context "when user has subscribed to #{frequency} emails" do
      before do
        subject.email_frequency = frequency
      end

      it { should validate_presence_of(:email) }
    end
  end

  describe '.estimate_skills' do
    let(:github_client) { double('github client') }
    let(:repos) { Project::LANGUAGES.sample(3).map { |l| Hashie::Mash.new(language: l) } }

    before do
      user.stub(:github_client).and_return(github_client)
      github_client.should_receive(:repos).and_return(repos)
      user.estimate_skills
    end

    subject { user }
    its(:skills) { should have(3).skills }
  end

  describe '.languages' do
    subject { user.languages }

    context 'when the user has no skillz' do
      it { should eq Project::LANGUAGES }
    end

    context 'when the user has skillz' do
      before do
        create :skill, language: 'JavaScript', user: user
      end

      it { should eq ['JavaScript'] }
    end
  end

  describe '.download_pull_requests' do
    let(:downloader)    { double('downloader') }
    let(:pull_request)  { mock_pull_request }

    before do
      downloader.should_receive(:pull_requests).and_return([pull_request])
      user.stub(:pull_request_downloader).and_return(downloader)
      user.download_pull_requests
    end

    subject { user }

    context 'when the pull request does not exist' do
      its(:pull_requests) { should have(1).pull_request }
    end

    context 'when the pull request already exists' do
      before do
        user.pull_requests.should_receive(:create).never
      end

      its(:pull_requests) { should have(1).pull_request }
    end
  end

  describe '.to_param' do
    subject { user.to_param }
    it { should eq user.nickname }
  end
end
