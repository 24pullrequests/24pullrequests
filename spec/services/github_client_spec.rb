require 'rails_helper'

describe GithubClient do
  subject(:github_client) { GithubClient.new('nickname', 'token') }

  let(:client) { double(:client) }

  before do
    expect(github_client).to receive(:client).and_return(client)
  end

  describe '#user_repository_languages' do
    let(:repos) { ['lan-1', 'lan-2', 'lan-1'].map { |l| Hashie::Mash.new(language: l) } }
    let(:client) { double(:client, repos: repos) }

    it "maps the user's repository languages uniqueley" do
      expect(github_client.user_repository_languages.length).to eq(2)
    end
  end

  describe '#user_events' do
    it "maps the user's repository languages" do
      expect(client).to receive(:user_events).with('nickname')

      github_client.user_events
    end
  end

  describe '#user_organizations' do
    it "maps the user's repository languages" do
      expect(client).to receive(:organizations).with('nickname')

      github_client.user_organizations
    end
  end

  describe '#high_rate_limit' do
    it 'checks the available rate_limit' do
      rate_limit = double(:rate_limit, remaining: 300)
      expect(client).to receive(:rate_limit).and_return(rate_limit)

      expect(github_client.high_rate_limit?).to be false
    end
  end

  describe '#issues' do
    it "returns a repositories issues" do
      repository = 'some-repository'
      expect(client).to receive(:issues).with(repository, {})

      github_client.issues(repository, {})
    end
  end

  describe '#commits' do
    it "returns a repositories commits" do
      repository = 'some-repository'
      expect(client).to receive(:commits).with(repository, {})

      github_client.commits(repository, {})
    end
  end

  describe '#repository' do
    it "returns a repository" do
      repository = '24pullrequests/24pullrequests'
      expect(client).to receive(:repo).with(repository)

      github_client.repository(repository)
    end
  end

  describe '#labels' do
    it "returns a repositories labels" do
      repository = '24pullrequests/24pullrequests'
      expect(client).to receive(:labels).with(repository)

      github_client.labels(repository)
    end
  end
end
