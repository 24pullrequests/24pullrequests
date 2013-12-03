source 'https://rubygems.org'
ruby "2.0.0"

gem 'rails', '4.0.2'

gem 'jquery-rails'

gem 'pg'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'haml-rails'
gem 'octokit'
gem 'bugsnag', '1.6.3'
gem 'rabl'
gem 'newrelic_rpm'
gem 'simplecov'
gem 'kaminari'
gem 'twitter', '5.0.0'
gem 'anjlab-bootstrap-rails', '~> 2.3.1', :require => 'bootstrap-rails'
gem 'simple_form', '3.0.0'
gem 'rack-google-analytics'
gem 'ffi', '1.9.0'
gem 'csv_shaper'

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
  gem 'poltergeist', '~> 1.4.0'
  gem 'launchy', '2.4.2'

  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'webmock', :require => false
  gem 'timecop', '0.7.0'

  gem 'coveralls', require: false
end

group :production do
  gem 'unicorn'
  gem 'foreman'
  gem 'memcachier'
  gem 'dalli'
  gem 'rails_12factor'
end
