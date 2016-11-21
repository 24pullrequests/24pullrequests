if ENV.key?('MAX_REQUESTS_PER_MINUTE')
  class Rack::Attack
    whitelist('allow asset requests') do |request|
      request.path.starts_with?('/assets')
    end

    throttle('req/ip', limit: Integer(ENV['MAX_REQUESTS_PER_MINUTE']), period: 1.minute, &:ip)
  end
end
