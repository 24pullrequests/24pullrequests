desc "Update pull requests"
task :update_pull_requests => :environment do
  PullRequest.all.each do |pr|
    pr.check_state
  end
end