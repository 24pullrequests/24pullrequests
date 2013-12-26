def award_coderwall_badges(user)
  conn = Faraday.new(:url => 'https://coderwall.com')
  api_key = ENV['CODERWALL_API_KEY']
  return if api_key.present?
  if user.pull_requests.year(CURRENT_YEAR).any?
    payload = {github:user.coderwall_username, badge:"TwentyFourPullRequestsParticipant#{CURRENT_YEAR}", date:"12/25/#{CURRENT_YEAR}", api_key:api_key}
    resp = conn.post '/award', payload.to_json, 'Content-Type' => 'application/json', :accept => 'application/json'
    p resp
  end
  if user.pull_requests.year(CURRENT_YEAR).length > 23
    payload = {github:user.coderwall_username, badge:"TwentyFourPullRequestsContinuous#{CURRENT_YEAR}", date:"12/25/#{CURRENT_YEAR}", api_key:api_key}
    resp = conn.post '/award', payload.to_json, 'Content-Type' => 'application/json', :accept => 'application/json'
  end
end

namespace :coderwall do
  desc 'Register coderwall awards'
  task :awards => :environment do
    User.all.each(&:award_coderwall_badges)
  end
end
