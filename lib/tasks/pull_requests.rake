namespace :pull_requests do
  desc 'Download new pull requests'
  task download_pull_requests: :environment do
    next unless Contribution.in_date_range?
    User.active.find_each do |user|
      user.download_contributions(User.load_user.token) rescue nil
      user.gift_unspent_contributions! rescue nil
    end
  end

  desc 'Download pull requests from active users'
  task download_active_pulls: :environment do
    next unless Contribution.in_date_range?
    Contribution.year(Tfpullrequests::Application.current_year).select(:user_id).distinct.all.map(&:user).each do |user|
      user.download_contributions(User.load_user.token) rescue nil
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
end
