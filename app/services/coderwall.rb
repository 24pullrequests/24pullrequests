class Coderwall
  PARTICIPANT = 'TwentyFourPullRequestsParticipant'
  CONTINUOUS = 'TwentyFourPullRequestsContinuous'

  def configured?
    api_key.present?
  end

  def award_badge(username, type)
    payload = { github:  username,
                badge:   "#{type}#{CURRENT_YEAR}",
                date:    "12/25/#{CURRENT_YEAR}",
                api_key: api_key }

    connection.post do |req|
      req.url '/award'
      req.headers['Content-Type'] = 'application/json'
      req.body = payload.to_json
    end
  end

  def connection
    @connection ||= Faraday.new(url: 'https://coderwall.com')
  end

  private

  def api_key
    @api_key ||= ENV['CODERWALL_API_KEY']
  end
end
