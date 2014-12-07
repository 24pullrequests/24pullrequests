desc 'Mark inactive projects'
task check_for_inactive_projects: :environment do
  count = 0
  Project.active.all.each do |project|
    begin
      user = User.load_user
      updated_at = project.repo(user.nickname, user.token).updated_at
      updated_recently = updated_at > Date.today - 6.months if updated_at
    rescue Octokit::NotFound => e
      updated_recently = false
    end

    unless updated_recently
      project.deactivate!
      count = count + 1
    end
  end

  puts "#{count} projects have been deactivated!"
end

task map_labels_from_github_issues: :environment do
  ACTIVE_LABELS = Label.all.map(&:name)

  Project.active.all.each do |project|
    user = User.load_user
    labels = project.issues(user.nickname, user.token, 6, open: true).map do |issue|
      issue.labels.map(&:name)
    end.flatten rescue []

    labels.try(:uniq!)

    labels.reject! { |label| !ACTIVE_LABELS.include?(label) }
    labels.each { |name| project.labels << Label.find_by_name(name) rescue nil }
  end
end
