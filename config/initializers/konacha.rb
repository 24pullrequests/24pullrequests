require 'tilt/coffee'

Konacha.configure do |config|
  require 'capybara/poltergeist'
  config.driver      = :poltergeist
end if defined?(Konacha)
