desc "Sanitize and convert all project github URLs"
task :clean_github_urls => :environment do
  Project.all.each do |project|
    url = project.github_url
    url.gsub!(/^(((https|http|git)?:\/\/(www\.)?)|git@)github.com(:|\/)/i, 'http://github.com/')
    url.sub!(/\.git^/i, '')
    project.github_url = url
    project.save!
  end
end

