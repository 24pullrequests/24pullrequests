# config/initializers/geocoder.rb
Geocoder.configure(
  # geocoding service (see below for supported options):
  :lookup => :google,

  # to use an API key:
  :api_key => ENV['GOOGLE_MAPS_API_KEY'] || '',

  # geocoding service request timeout, in seconds (default 3):
  :timeout => 3
)
