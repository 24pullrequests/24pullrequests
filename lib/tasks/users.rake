namespace :users do
  desc 'Reset user pull request counts'
  task reset_contribution_count: :environment do
    User.all.update_all(contributions_count: 0)
  end

  desc 'Refresh pull request counts'
  task refresh_contribution_counts: :environment do
    User.reset_column_information
    User.all.find_each(&:update_contribution_count)
  end

  desc 'Gift unspent pull requests'
  task gift_unspent_requests: :environment do
    User.all.find_each(&:gift_unspent_contributions!)
  end
end
