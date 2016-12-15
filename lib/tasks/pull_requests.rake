desc 'Refresh pull request counts'
task refresh_pull_request_counts: :environment do
  User.reset_column_information
  User.all.find_each(&:update_pull_request_count)
end

desc 'Download new pull requests'
task download_pull_requests: :environment do
  next unless PullRequest.in_date_range?
  User.all.find_each do |user|
    user.download_pull_requests(User.load_user.token) rescue nil
    user.gift_unspent_pull_requests! rescue nil
  end
end

desc 'Download pull requests from active users'
task download_active_pulls: :environment do
  next unless PullRequest.in_date_range?
  PullRequest.year(Tfpullrequests::Application.current_year).select(:user_id).distinct.all.map(&:user).each do |user|
    user.download_pull_requests(User.load_user.token) rescue nil
    user.gift_unspent_pull_requests! rescue nil
  end
end

desc 'Update pull requests'
task update_pull_requests: :environment do
  next unless PullRequest.in_date_range?
  PullRequest.year(Tfpullrequests::Application.current_year).all.find_each do |pr|
    pr.check_state rescue nil
  end
end

desc 'Gift unspent pull requests'
task gift_unspent_requests: :environment do
  User.all.find_each(&:gift_unspent_pull_requests!)
end
