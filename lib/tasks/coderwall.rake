namespace :coderwall do
  desc 'Register coderwall awards'
  task :awards => :environment do
    conn = Faraday.new(:url => 'https://coderwall.com')
    api_key = ENV['CODERWALL_API_KEY']
    if api_key.present?
      User.all.each do |user|
        if user.pull_requests.any?
          payload = {github:user.nickname, badge:"TwentyFourPullRequestsParticipant", date:"12/25/#{CURRENT_YEAR}", api_key:api_key}
          resp = conn.post '/award', payload.to_json, 'Content-Type' => 'application/json', :accept => 'application/json'
        end
        if user.pull_requests.length > 23
          payload = {github:user.nickname, badge:"TwentyFourPullRequestsContinuous", date:"12/25/#{CURRENT_YEAR}", api_key:api_key}
          resp = conn.post '/award', payload.to_json, 'Content-Type' => 'application/json', :accept => 'application/json'
        end
      end
    end
  end
end