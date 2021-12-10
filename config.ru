# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

use Rack::Deflater
use Rack::CanonicalHost, ENV['CANONICAL_HOST'] if ENV['CANONICAL_HOST']

run Rails.application
Rails.application.load_server
