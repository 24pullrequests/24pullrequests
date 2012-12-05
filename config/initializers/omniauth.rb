module OmniAuth
  module Strategies
    class Developer2 < Developer
      credentials do
        { 'token' => request.params[options.uid_field.to_s] }
      end
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer2, :fields => [:nickname], :uid_field => :nickname unless Rails.env.production?
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

Rails.application.config.default_provider = Rails.env.development? ? :developer2 : :github
