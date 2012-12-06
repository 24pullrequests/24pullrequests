object @user
attributes :id, :nickname, :gravatar_id, :github_profile, :twitter_profile, :pull_requests_count
node(:link) { |user| user_url(user) }
child :pull_requests do
  extends 'pull_requests/show'
end
