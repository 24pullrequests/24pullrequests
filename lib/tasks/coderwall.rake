namespace :coderwall do
  desc 'Register coderwall awards'
  task :awards => :environment do
    User.all.each do |u|
      p u.id
      u.award_coderwall_badges
    end
  end
end
