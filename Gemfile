source 'https://rubygems.org'
ruby '2.2.3'

gem 'rails', '4.2.5'

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
gem 'bootstrap-sass'
gem 'jquery-datetimepicker-rails'
gem 'autoprefixer-rails'
gem 'simple_form'
gem 'ffi'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'octicons-rails'
gem 'rack-canonical-host'
gem 'draper'
gem 'responders'
gem 'sprockets'
gem 'gmaps4rails'
gem 'geocoder'
gem 'lodash-rails'
gem 'mime-types', '2.6.2' # LOCKED DOWN per issue #299
gem 'typhoeus'

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'thin'
  gem 'rubocop', require: false
  gem 'web-console'
  gem 'meta_request'
end

group :development, :test, :cucumber do
  gem 'i18n-tasks'
  gem 'rspec-rails'
  gem 'coveralls', require: false
  gem 'codeclimate-test-reporter', require: nil

  gem 'rspec-its', require: false
  gem 'rspec-collection_matchers', require: false
  gem 'rspec-activemodel-mocks', require: false
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

  # Javascript
  gem 'konacha'
  gem 'chai-jquery-rails'
  gem 'sinon-chai-rails'
  gem 'sinon-rails'
  gem 'ejs'
end

group :production do
  gem 'puma'
  gem 'foreman'
  gem 'memcachier'
  gem 'dalli'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'bugsnag'
  gem 'rack-google-analytics'
end
