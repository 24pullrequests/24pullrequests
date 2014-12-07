attributes :id, :nickname, :gravatar_id, :github_profile, :twitter_profile, :pull_requests_count
child(:organisations) do
  attributes :login, :avatar_url
  node(:link) { |organisation| organisation_url(organisation) }
end
node(:link) { |user| user_url(user) }
