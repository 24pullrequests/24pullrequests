source 'https://rubygems.org'
ruby "2.0.0"

gem 'rails', '3.2.14'

gem 'jquery-rails'

gem 'pg'
gem 'unicorn'
gem 'foreman'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'haml-rails'
gem 'octokit'
gem "bugsnag"
gem 'rabl'
gem 'newrelic_rpm'
gem 'simplecov'
gem 'kaminari'
gem 'twitter'
gem 'anjlab-bootstrap-rails', '2.3.1.2', :require => 'bootstrap-rails'
gem 'simple_form'
gem 'rack-google-analytics'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development do
  gem 'thin'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'brakeman'

  # Auto testing
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'ruby_gntp'
  gem 'rb-fsevent'

  # Javascript
  gem 'konacha'
  gem 'chai-jquery-rails'
  gem 'sinon-chai-rails'
  gem 'sinon-rails'
  gem 'ejs'
end

group :test do
  gem "capybara"
  gem 'capybara-webkit'
  gem 'launchy'

  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'webmock', :require => false
  gem 'poltergeist'
  gem 'timecop'
end

group :production do
  gem 'memcachier'
  gem 'dalli'
end
