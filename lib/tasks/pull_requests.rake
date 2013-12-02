def load_user
  u = User.order('created_at desc').limit(50).sample(1).first
  if u.github_client.rate_limit.remaining < 4000
    load_user
  else
    u
  end
end

desc "Download new pull requests"
task :download_pull_requests => :environment do
  User.all.each do |user|
    user.download_pull_requests(load_user.token) rescue nil
  end
end

desc 'Download pull requests from active users'
task :download_active_pulls => :environment do
  PullRequest.year(2013).select(:user_id).distinct.all.map(&:user).each do |user|
    user.download_pull_requests(load_user.token) rescue nil
  end
end
