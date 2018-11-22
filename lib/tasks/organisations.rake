namespace :organisations do
  desc 'Update organisations pull_request_count'
  task update_pull_request_count: :environment do
    next unless PullRequest.in_date_range?
    Organisation.all.find_each(&:update_pull_request_count)
  end

  desc 'Reset organisations pull_request_count'
  task reset_pull_request_count: :environment do
    Organisation.all.update_all(pull_request_count: 0)
  end
end

desc 'Download user organisations'
task download_user_organisations: :environment do
  next unless PullRequest.in_date_range?
  User.all.find_each do |user|
    puts "Importing organisations for #{user.nickname}"
    user.download_user_organisations(User.load_user.token) rescue nil
  end
end
