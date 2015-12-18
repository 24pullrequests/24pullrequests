require 'rails_helper'

describe RepoWithLabels do
  let(:client) do
    instance_double('GithubClient')
  end

  describe '#repo' do
    it 'Repository with name' do
      res = described_class.new(client, 'foo/bar')
      expect(res.name).to eq('foo/bar')
    end

    it 'Repository with github url' do
      res = described_class.new(client, 'http://github.com/foo/bar')
      expect(res.name).to eq('foo/bar')
    end
  end

  describe '#call' do
    let(:res) do
      described_class.new(client, 'foo/bar')
    end

    it 'successful' do
      # This tests that to_hash is called
      data = instance_double('Sawyer::Resource', to_hash: {
        html_url: 'https://github.com/foo/bar' })

      allow(client).to receive(:repository).with('foo/bar')
        .and_return(data)

      allow(client).to receive(:labels).and_return([
        { "name" => 'foo' },
        { "name" => 'bar' }
      ])

      allow(Project).to receive(:exists?)
        .with(github_url: 'https://github.com/foo/bar')
        .and_return(true)

      expect(res.call.as_json).to eq({
        'data' => {
          'repository' => {
            'html_url' => 'https://github.com/foo/bar'
          },
          'labels' => %w(foo bar),
          'repo_exists' => true
        },
        'status' => 200
      })
    end

    # Test to make sure it doesnt error
    it 'successful but no html_url' do
      data = instance_double('Sawyer::Resource', to_hash: {
        foo: 'bar' })

      allow(client).to receive(:repository).with('foo/bar')
        .and_return(data)

      allow(client).to receive(:labels).and_return([
        { "name" => 'foo' },
        { "name" => 'bar' }
      ])

      expect(res.call.as_json).to eq(
        'data' => {
          'repository' => {
            'foo' => 'bar'
          },
          'labels' => %w(foo bar),
          'repo_exists' => false
        },
        'status' => 200
      )
    end

    it 'InvalidRepository' do
      allow(client).to receive(:repository)
        .and_raise(Octokit::InvalidRepository)

      expect(res.call.as_json).to eq(
        'data' => { 'message' => 'Invalid repository' },
        'status' => 422)
    end

    it 'NotFound' do
      allow(client).to receive(:repository)
        .and_raise(Octokit::NotFound)

      expect(res.call.as_json).to eq(
        'data' => { 'message' => 'Repo not found' },
        'status' => 404)
    end

    it 'TooManyRequests' do
      allow(client).to receive(:repository)
        .and_raise(Octokit::TooManyRequests)

      expect(res.call.as_json).to eq(
        'data' => { 'message' => 'Too many requests' },
        'status' => 403)
    end

    it 'Unauthorized' do
      allow(client).to receive(:repository)
        .and_raise(Octokit::Unauthorized)

      expect(res.call.as_json).to eq(
        'data' => { 'message' => 'Bad credentials' },
        'status' => 401)
    end
  end
end
