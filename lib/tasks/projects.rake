desc "Mark inactive projects"
task :check_for_inactive_projects => :environment do
  count = 0
  Project.active.all.each do |project|
    begin
      updated_at = project.repo(load_user.github_client).updated_at
      updated_recently = updated_at > Date.today-6.months
    rescue
      updated_recently = false
    end

    has_active_issues = project.issues(load_user.github_client).any? rescue(false)  unless updated_recently

    unless updated_recently or has_active_issues
      project.deactivate!
      count = count+1
    end
  end

  puts "#{count} projects have been deactivated!"
end
