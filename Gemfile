source 'http://rubygems.org'
ruby "2.0.0"

gem 'rails', '3.2.12'
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
gem 'jquery-rails', '2.1.4'
gem "less-rails"
gem "twitter-bootstrap-rails", '2.2.4'
gem 'simple_form'
gem 'rack-google-analytics'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', '0.10.2', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'thin'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'factory_girl_rails'
  gem 'faker'

  # Auto testing
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'ruby_gntp'
  gem 'rb-fsevent', '~> 0.9.1'

  # Javascript
  gem 'konacha'
  gem 'chai-jquery-rails'
  gem 'sinon-chai-rails'
  gem 'sinon-rails'
  gem 'ejs'
end

group :test do
  gem "capybara", '1.1.4'
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
