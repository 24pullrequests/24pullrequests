def load_user
  user = User.order('created_at desc').limit(50).sample(1).first
  return user if user.github_client.high_rate_limit?

  load_user
end

desc "Download user organisations"
task :download_user_organisations => :environment do
  next unless PullRequest.in_date_range?
  User.all.each do |user|
    puts "Importing organisations for #{user.nickname}"
    user.download_user_organisations(load_user.token) rescue nil
  end
end

desc "Download new pull requests"
task :download_pull_requests => :environment do
  next unless PullRequest.in_date_range?
  User.all.each do |user|
    user.download_pull_requests(load_user.token) rescue nil
  end
end

desc 'Download pull requests from active users'
task :download_active_pulls => :environment do
  next unless PullRequest.in_date_range?
  PullRequest.year(CURRENT_YEAR).select(:user_id).distinct.all.map(&:user).each do |user|
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

desc "Update pull requests"
task :update_pull_requests => :environment do
  next unless PullRequest.in_date_range?
  PullRequest.year(CURRENT_YEAR).all.each do |pr|
    pr.check_state rescue nil
  end
end
