source 'https://rubygems.org'
ruby '3.4.7'

gem 'rails', '8.1.1'

gem 'jquery-rails'
gem 'pg', '~> 1.6.1'
gem 'omniauth', '~> 2.1'
gem 'omniauth-github'
gem 'octokit'
gem 'rabl'
gem 'kaminari', github: 'keithyoder/kaminari', branch: 'deprecator-notify'
gem 'bootstrap-sass'
gem 'jquery-datetimepicker-rails'
gem 'simple_form'
gem 'coffee-rails'
gem 'uglifier'
gem 'octicons_helper', '~> 19.0'
gem 'rack-canonical-host'
gem 'draper'
gem 'responders'
gem 'typhoeus'
gem 'sassc-rails'
gem 'puma'
gem 'rack-attack'
gem 'bootsnap', require: false
gem 'sprockets', '< 5.0.0'
gem 'faraday', '2.14.0'
gem "commonmarker", "~> 2.5"
gem 'faraday-retry'
gem 'observer'
gem 'ostruct'

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console'
end

group :development, :test, :cucumber do
  gem 'i18n-tasks'
  gem 'rspec-rails'
  gem 'rails-controller-testing'

  gem 'rspec-its', require: false
  gem 'rspec-collection_matchers', require: false
  gem 'rspec-activemodel-mocks', require: false
  gem 'factory_bot_rails', '6.5.1'
  gem 'faker'
  gem 'brakeman'
  gem 'cuprite'

  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'webmock', require: false
  gem 'timecop'
  gem 'christmas_tree_formatter'
  gem 'benchmark'

end

group :production do
  gem 'foreman'
  gem 'dalli'
  gem 'bugsnag'
  gem 'rack-google-analytics'
end
