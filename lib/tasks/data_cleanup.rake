desc "Deduplicate projects with the same github url"
task :deduplicate_projects => :environment do

  duplicate_project_groups = Project.all.group_by(&:github_url).select { |k, v| v.count > 1 }

  duplicate_project_groups.values.each do |project_group|
    earliest = project_group.sort_by(&:created_at).first

    (project_group - [earliest]).map(&:destroy)
  end

end