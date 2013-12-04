desc "Mark inactive projects"
task :check_for_inactive_projects => :environment do
  count = 0
  Project.active.all.each do |project|
    has_active_issues = project.issues(load_user.github_client).any? rescue false

    unless has_active_issues
      project.deactivate!
      count = count+1
    end
  end

  puts "#{count} projects have been deactivated!"
end
