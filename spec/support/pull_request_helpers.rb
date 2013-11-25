module PullRequestHelpers
  # Creates a mock pull request in json format.
  def mock_pull_request
    {
      'payload' => {
        'pull_request' => {
          'title'      => Faker::Lorem.words.first,
          'issue_url'  => Faker::Internet.url,
          'created_at' => DateTime.now.to_s,
          'state'      => 'open',
          'body'       => Faker::Lorem.paragraphs.join('\n'),
          'merged'     => false,
        }
      },
      'repo' => {
        'name' => Faker::Lorem.words.first
      }
    }
  end

  def mock_issue
    {
      'state'    => 'closed',
      'comments' => '5'
    }
  end
end

RSpec.configure do |config|
  config.include PullRequestHelpers
end
