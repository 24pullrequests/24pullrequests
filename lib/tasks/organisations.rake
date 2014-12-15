
namespace :organisations do
  desc 'Update organisations pull_request_count'
  task update_pull_request_count: :environment do
    next unless PullRequest.in_date_range?
    Organisation.all.each do |organisation|
      organisation.update_attribute(:pull_request_count, organisation.pull_requests.count)
    end
  end
end

desc 'Download user organisations'
task download_user_organisations: :environment do
  next unless PullRequest.in_date_range?
  User.all.each do |user|
    puts "Importing organisations for #{user.nickname}"
    user.download_user_organisations(User.load_user.token) rescue nil
  end
end
