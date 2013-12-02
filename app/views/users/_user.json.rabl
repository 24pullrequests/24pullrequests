attributes :id, :nickname, :gravatar_id, :github_profile, :twitter_profile, :pull_requests_count
child(:organisations) { attributes :login, :avatar_url }
node(:link) { |user| user_url(user) }
