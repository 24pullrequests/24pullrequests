source 'https://rubygems.org'
ruby '2.1.4'

gem 'rails', '4.1.7'

gem 'jquery-rails'

gem 'pg'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'haml-rails'
gem 'octokit'
gem 'bugsnag'
gem 'rabl'
gem 'newrelic_rpm'
gem 'simplecov'
gem 'kaminari'
gem 'twitter'
gem 'anjlab-bootstrap-rails', '~> 3.0.3.0', require: 'bootstrap-rails'
gem 'jquery-datetimepicker-rails', '~> 2.3.7.0'
gem 'simple_form'
gem 'rack-google-analytics'
gem 'ffi', '1.9.3'
gem 'csv_shaper'

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'thin'
  gem 'quiet_assets'
end

group :development, :test, :cucumber do
  gem 'rspec-rails'
  gem 'coveralls', require: false
  gem 'codeclimate-test-reporter', require: nil

  gem 'rspec-its'
  gem 'rspec-collection_matchers'
  gem 'rspec-activemodel-mocks'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'brakeman'
  gem 'poltergeist'
  gem 'launchy'

  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'webmock', require: false
  gem 'timecop'

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

group :production do
  gem 'unicorn'
  gem 'foreman'
  gem 'memcachier'
  gem 'dalli'
  gem 'rails_12factor'
end
