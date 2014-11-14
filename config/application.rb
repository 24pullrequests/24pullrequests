require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require 'open-uri'
# require "rails/test_unit/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Tfpullrequests
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.i18n.default_locale = :en
    config.i18n.fallbacks = true
    config.i18n.available_locales = [ :en, :el, :es, :pt_br, :fi, :fr, :de, :ru, :uk, :th, :it, :nb, :ta, :tr, :zh_Hans, :zh_Hant ]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.initialize_on_precompile = false

    config.exceptions_app = self.routes

    I18n.config.enforce_available_locales = false

    # Memoize at boot up to prevent GitHub's rate limiting. This should work
    # fine for now.
    config.contributors = begin
      Timeout::timeout(5) {
        Octokit.contributors('24pullrequests/24pullrequests')
      }
    rescue => e
      Rails.logger.error "Error when memoizing contributors at boot up:\n #{e.inspect}"
      []
    end

    config.organization_members = begin
      Timeout::timeout(5) {
        Octokit.organization_members('24pullrequests')
      }
    rescue => e
      Rails.logger.error "Error when memoizing organization members at boot up:\n #{e.inspect}"
      []
    end
  end
end
