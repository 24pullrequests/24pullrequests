namespace :tfpullrequests do
  desc 'prepare for new year'
  task prepare: :environment do
    rake_tasks = [
      'users:reset_contribution_count',
      'organisations:reset_contribution_count',
      'projects:reactivate_inactive_projects',
      'projects:check_for_inactive_projects'
    ] 
    rake_tasks.each do |task|
      Rake::Task[task].invoke
    end
  end
end