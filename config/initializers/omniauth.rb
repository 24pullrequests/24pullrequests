Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, :fields => [:nickname], :uid_field => :nickname unless Rails.env.production?
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end

Rails.application.config.default_provider =  Rails.env.production? ? :github : :developer
