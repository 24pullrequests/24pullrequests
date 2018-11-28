namespace :users do
  desc 'Reset user pull request counts'
  task reset_contribution_count: :environment do
    User.all.update_all(contributions_count: 0)
  end
end

desc 'Refresh pull request counts'
task refresh_contribution_counts: :environment do
  User.reset_column_information
  User.all.find_each(&:update_contribution_count)
end

desc 'Download new pull requests'
task download_pull_requests: :environment do
  next unless Contribution.in_date_range?
  User.all.find_each do |user|
    user.download_pull_requests(User.load_user.token) rescue nil
    user.gift_unspent_contributions! rescue nil
  end
end

desc 'Download pull requests from active users'
task download_active_pulls: :environment do
  next unless Contribution.in_date_range?
  Contribution.year(Tfpullrequests::Application.current_year).select(:user_id).distinct.all.map(&:user).each do |user|
    user.download_pull_requests(User.load_user.token) rescue nil
    user.gift_unspent_contributions! rescue nil
  end
end

desc 'Update pull requests'
task update_pull_requests: :environment do
  next unless Contribution.in_date_range?
  Contribution.year(Tfpullrequests::Application.current_year).all.find_each do |pr|
    pr.check_state rescue nil
  end
end

desc 'Gift unspent pull requests'
task gift_unspent_requests: :environment do
  User.all.find_each(&:gift_unspent_contributions!)
end
