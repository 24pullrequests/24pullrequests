desc "Download new pull requests"
task :download_pull_requests => :environment do

  def load_user
    u = User.order('created_at desc').limit(50).sample(1).first
    if u.github_client.rate_limit.remaining < 4000
      p 'finding another user'
      load_user
    else
      u
    end
  end

  User.all.each do |user|
    user.download_pull_requests(load_user.token)
  end
end
