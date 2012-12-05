namespace :twitter do
  desc 'Fetch and set the twitter nickname for each user that has twitter linked'
  task :fetch_and_update_nicknames => :environment do
    User.all.each do |user|
      user.update_attribute(:twitter_nickname, user.twitter.settings.screen_name) if user.twitter_token.present? && user.twitter_secret.present?
    end
  end
end
