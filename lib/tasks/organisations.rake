namespace :organisations do
  desc 'Update organisations contribution_count'
  task update_contribution_count: :environment do
    next unless Contribution.in_date_range?
    Organisation.all.find_each(&:update_contribution_count)
  end

  desc 'Reset organisations contribution_count'
  task reset_contribution_count: :environment do
    Organisation.all.update_all(contribution_count: 0)
  end
end

desc 'Download user organisations'
task download_user_organisations: :environment do
  next unless Contribution.in_date_range?
  User.all.find_each do |user|
    puts "Importing organisations for #{user.nickname}"
    user.download_user_organisations(User.load_user.token) rescue nil
  end
end
