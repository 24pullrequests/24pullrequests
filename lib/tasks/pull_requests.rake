desc "Download new pull requests"
task :download_pull_requests => :environment do
  User.all.each do |user|
    user.download_pull_requests
  end
end

desc "Render pull request bodies as markdown"
task :render_markdown_bodies => :environment do
  PullRequest.all.each do |pr|
    pr.render_markdown
    pr.save!
  end
end
