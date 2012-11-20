source 'https://rubygems.org'

gem 'rails', '3.2.9'
gem 'pg'
gem 'unicorn'
gem 'foreman'
gem 'omniauth'
gem 'omniauth-github'
gem 'haml-rails'
gem 'rest-client'
gem 'typhoeus'

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

# I'm using mysql for dev (baris)
group :development do
  gem 'mysql2'

  # for heroku db:pull with rbenv
  gem 'heroku'
  gem 'taps'
  gem 'sqlite3'
end