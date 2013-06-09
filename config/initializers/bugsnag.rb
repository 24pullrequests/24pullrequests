if Rails.env.production?
  Bugsnag.configure do |config|
    config.api_key = "2dd469c5b922330293a39214672a53f8"
  end
end