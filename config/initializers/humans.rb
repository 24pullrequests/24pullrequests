module Humans
  class Application < Rails::Application
    config.after_initialize do
      if Rails.env.production?
        # Memoize at boot up to prevent GitHub's rate limiting. This should work
        # fine for now.
        access_token = User.limit(1).order("RANDOM()").pluck(:token).first
        config.octokit_client = Octokit::Client.new(access_token: access_token,
                                                    auto_paginate: true)

        config.contributors = begin
          Timeout::timeout(5) {
            config.octokit_client.contributors('24pullrequests/24pullrequests')
          }
        rescue => e
          puts "Error when memoizing contributors at boot up:\n #{e.inspect}"
          []
        end

        config.organization_members = begin
          Timeout::timeout(5) {
            config.octokit_client.organization_members('24pullrequests')
          }
        rescue => e
          puts "Error when memoizing organization members at boot up:\n #{e.inspect}"
          []
        end
      else
        config.contributors = config.organization_members = []
      end
    end
  end
end
