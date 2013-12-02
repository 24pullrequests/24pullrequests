desc "Update pull requests"
task :update_pull_requests => :environment do
  PullRequest.year(CURRENT_YEAR).all.each do |pr|
    pr.check_state rescue nil
  end
end
