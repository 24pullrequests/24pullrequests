desc "Download new pull requests"
task :download_pull_requests => :environment do
  User.all.each do |user|
    user.download_pull_requests
  end
end