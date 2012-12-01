source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.9'
gem 'pg'
gem 'unicorn'
gem 'foreman'
gem 'omniauth'
gem 'omniauth-github'
gem 'haml-rails'
gem 'octokit'
gem "bugsnag"
gem 'newrelic_rpm'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

end

gem 'jquery-rails'

gem "less-rails"
gem "twitter-bootstrap-rails"
gem 'simple_form'

gem 'rack-google-analytics'

# I'm using mysql for dev (baris)
group :development do
  gem 'mysql2'
  gem 'thin'
  # for heroku db:pull with rbenv
  gem 'heroku'
  gem 'taps'
  gem 'sqlite3'

  gem 'quiet_assets'
  gem 'guard-rspec'
  gem 'rb-fsevent', '~> 0.9.1'
end

gem "rspec-rails", :group => [:test, :development]

group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'rb-fsevent', '~> 0.9.1'
end
