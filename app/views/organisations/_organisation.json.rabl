attributes :login, :avatar_url
child(:users) { attributes :id, :nickname, :gravatar_id, :github_profile, :twitter_profile, :contributions_count }
node(:link) { |organisation| organisation_url(organisation) }
