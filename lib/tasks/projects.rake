require_relative '../json_api'

desc 'Mark inactive projects'
task check_for_inactive_projects: :environment do
  count = 0
  Project.active.all.find_each do |project|
    begin
      user = User.load_user
      score = project.score(user.nickname, user.token)
    rescue Octokit::NotFound, Octokit::InvalidRepository
      score = 0
    rescue Octokit::Unauthorized
      score = 99
    end

    puts "#{project.name} - #{score}"

    if score < 6
      project.deactivate!
      count += 1
    end
  end

  puts "#{count} projects have been deactivated!"
end

desc 'Recheck inactive projects'
task reactivate_inactive_projects: :environment do
  count = 0
  Project.where(inactive: true).find_each do |project|
    begin
      user = User.load_user
      score = project.score(user.nickname, user.token)
    rescue Octokit::NotFound, Octokit::InvalidRepository
      score = 0
    rescue Octokit::Unauthorized
      score = 99
    end

    puts "#{project.name} - #{score}"

    if score > 5
      project.update_attribute(:inactive, false)
      count += 1
    end
  end

  puts "#{count} projects have been reactivated!"
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

namespace :projects do
  desc 'Fetch contribulator scores'
  task :contribulator => :environment do
    next unless PullRequest.in_date_range?

    api = JsonApi::PaginatedCollection.new(
      domain: 'https://contribulator.herokuapp.com',
      path:   '/api/projects'
    )

    api.fetch.each do |item|
      github_url = "https://github.com/#{item['attributes']['name_with_owner']}"

      if p = Project.find_by_github_repo(github_url)
        p.update_attributes(contribulator: item['attributes']['score'].to_i)
        puts "Updated #{p.name} contribulator #{p.contribulator}"
      end
    end
  end
end
