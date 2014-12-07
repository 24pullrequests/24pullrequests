desc 'Archive old pull requests'
task archive_old_pull_requests: :environment  do
  copy_query = 'INSERT INTO archived_pull_requests (title, issue_url, body, state, merged, created_at, repo_name, user_id, language, comments_count)
    SELECT title, issue_url, body, state, merged, created_at, repo_name, user_id, language, comments_count FROM pull_requests
    WHERE EXTRACT(year FROM "created_at") < ' + CURRENT_YEAR.to_s

  ActiveRecord::Base.connection.execute(copy_query)

  delete_query = 'DELETE FROM pull_requests WHERE EXTRACT(year FROM "created_at") < ' + CURRENT_YEAR.to_s

  ActiveRecord::Base.connection.execute(delete_query)
end

desc 'Refresh pull request counts'
task refresh_pull_request_counts: :environment do
  User.reset_column_information
  User.all.each do |u|
    User.reset_counters(u.id, :pull_requests)
  end
end

desc 'Download new pull requests'
task download_pull_requests: :environment do
  next unless PullRequest.in_date_range?
  User.all.each do |user|
    user.download_pull_requests(User.load_user.token) rescue nil
  end
end

desc 'Download pull requests from active users'
task download_active_pulls: :environment do
  next unless PullRequest.in_date_range?
  PullRequest.year(CURRENT_YEAR).select(:user_id).distinct.all.map(&:user).each do |user|
    user.download_pull_requests(User.load_user.token) rescue nil
  end
end

desc 'Update pull requests'
task update_pull_requests: :environment do
  next unless PullRequest.in_date_range?
  PullRequest.year(CURRENT_YEAR).all.each do |pr|
    pr.check_state rescue nil
  end
end
