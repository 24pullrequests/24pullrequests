source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails', '4.1.8'

gem 'jquery-rails'
gem 'pg'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'haml-rails'
gem 'octokit'
gem 'rabl'
gem 'kaminari'
gem 'twitter'
gem 'bootstrap-sass', '~> 3.3.1'
gem 'jquery-datetimepicker-rails', '~> 2.3.7.0'
gem 'autoprefixer-rails'
gem 'simple_form'
gem 'ffi'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'octicons-rails'
gem 'rack-canonical-host'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'thin'
  gem 'quiet_assets'
  gem 'rubocop', '~> 0.27', require: false
end

group :development, :test, :cucumber do
  gem 'rspec-rails'
  gem 'coveralls', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'pullreview-coverage', require: false

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
  gem 'simplecov'

  # Auto testing
  gem 'guard-rspec', '~> 4.4.2'
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
  gem 'newrelic_rpm'
  gem 'bugsnag'
  gem 'rack-google-analytics'
end
