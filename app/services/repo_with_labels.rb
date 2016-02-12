class RepoWithLabels
  attr_reader :client, :name

  def initialize(client, name)
    @client = client
    @name   = name.split('github.com/').last
  end

  def call
    res = fetch_repo

    if res[:status] == 200
      res[:data][:repo_exists] = repo_exists?(res)
      res[:data][:labels]      = fetch_labels
    end

    res
  end

  private

  def repo_exists?(res)
    Project.exists?(github_url: res[:data][:repository][:html_url])
  end

  def fetch_repo
    # We need to make sure the Sawyer::Resource is transformed
    # into a hash else rails will turn the {foo: bar} into a
    # [['foo', 'bar']] when sending it in a JSON response
    response({ repository: client.repository(name).to_hash }, 200)
  rescue Octokit::InvalidRepository
    response({ message: 'Invalid repository' }, 422)
  rescue Octokit::NotFound
    response({ message: 'Repo not found' }, 404)
  rescue Octokit::TooManyRequests
    response({ message: 'Too many requests' }, 403)
  rescue Octokit::Unauthorized
    response({ message: 'Bad credentials' }, 401)
  rescue Octokit::RepositoryUnavailable
    response({ message: 'Repository access blocked' }, 403)
  end

  def fetch_labels
    client.labels(name).map { |e| e['name'] }
  end

  def response(data, status)
    { data: data, status: status }
  end
end
