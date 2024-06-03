# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require 'rails/all'

require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'rspec/active_model/mocks'
require 'rspec/its'
require 'rspec/collection_matchers'
# require 'rspec/autorun'
require 'shoulda-matchers'
require 'webmock'
require 'webmock/rspec'

OmniAuth.config.test_mode = true

WebMock.disable_net_connect! allow_localhost: true

FactoryBot.allow_class_lookup = false

require 'capybara/cuprite'
Capybara.javascript_driver = :cuprite
Capybara.default_max_wait_time = 10

Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(app, browser_options: { 'no-sandbox': nil })
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = ["#{::Rails.root}/spec/fixtures"]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # Database Cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:all) do
    DeferredGarbageCollection.start
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before do
    allow_any_instance_of(User).to receive(:estimate_skills).and_return(nil)
    Timecop.travel(Date.parse("12/12/#{Tfpullrequests::Application.current_year}"))
  end

  config.after do
    Timecop.return
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.include FactoryBot::Syntax::Methods
  config.include Capybara::DSL

  # 10/1/2015: Needed for shoulda-matchers 3.0.
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec

      with.library :rails
    end
  end

  Capybara.server = :puma, { Silent: true }
end
