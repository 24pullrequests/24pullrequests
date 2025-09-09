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
  provider :developer2, fields: [:nickname], uid_field: :nickname unless Rails.env.production?
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end

# OmniAuth 2.0 requires CSRF protection - only allow POST in production
# For test environment, we need to allow GET for specs to work
if Rails.env.test?
  OmniAuth.config.allowed_request_methods = [:get, :post]
  OmniAuth.config.silence_get_warning = true
else
  # Production and development should use POST only for security
  OmniAuth.config.allowed_request_methods = [:post]
end

Rails.application.config.default_provider = (Rails.env.development? && ENV['GITHUB_KEY'].blank?) ? :developer2 : :github
