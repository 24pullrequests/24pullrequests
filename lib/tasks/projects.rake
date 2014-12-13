desc 'Mark inactive projects'
task check_for_inactive_projects: :environment do
  count = 0
  Project.active.all.each do |project|
    begin
      user = User.load_user
      score = project.score(user.nickname, user.token)
    rescue Octokit::NotFound
      score = 0
    end

    puts "#{project.name} - #{score}"

    if score == 0
      project.deactivate!
      count += 1
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
