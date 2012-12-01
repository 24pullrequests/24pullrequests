namespace :cleanup do
  desc "Make Projects with relative GitHub URLs fully-qualified"
  task :projects => :environment do
    Project.all.each do |project|
      project.update_attributes(github_url: "http://#{project.github_url}") \
        unless project.github_url =~ /\Ahttp\:\/\//
      puts "URL of #{project.name} is '#{project.github_url}'" if project.save
    end
  end
end
