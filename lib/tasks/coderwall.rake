namespace :coderwall do
  desc 'Register coderwall awards'
  task :awards => :environment do
    PullRequest.year(CURRENT_YEAR).includes(:user).map(&:user).uniq.compact.sort_by(&:id).each do |u|
      u.award_coderwall_badges
    end
  end
end
