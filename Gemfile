source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.9'
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

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '0.10.2', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

end

gem 'jquery-rails'

gem "less-rails"
gem "twitter-bootstrap-rails"
gem 'simple_form'

gem 'rack-google-analytics'

group :development do
  gem 'thin'
  # for heroku db:pull with rbenv
  gem 'heroku'
  gem 'taps'
  gem 'sqlite3'

  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'rb-fsevent', '~> 0.9.1'

  # Javascript
  gem 'konacha'
  gem 'chai-jquery-rails'
  gem 'sinon-chai-rails'
  gem 'sinon-rails'
  gem 'ejs'
  gem "factory_girl_rails"
  gem 'faker'
end

group :test do
  gem "capybara"
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'webmock', require: false
  gem 'poltergeist'
end
