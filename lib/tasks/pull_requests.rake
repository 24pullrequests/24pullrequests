def load_user
  u = User.order('created_at desc').limit(50).sample(1).first
  if u.github_client.rate_limit.remaining < 4000
    load_user
  else
    u
  end
end

desc "Download user organisations"
task :download_user_organisations => :environment do
  User.all.each do |user|
    puts "Importing organisations for #{user.nickname}"
    user.download_user_organisations(load_user.token) rescue nil
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

desc 'Clean the pulls with empty link'
task :clean_empty_link_pulls => :environment do
  PullRequest.year(CURRENT_YEAR).where('issue_url' => nil).each do |pr|
    pr.gifts.destroy_all
    pr.destroy
  end
end
