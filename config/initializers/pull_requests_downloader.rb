Rails.application.config.pull_request_downloader = if Rails.env.production?
                                                     ->(login, oauth_token) { PullRequestDownloader.new(login, oauth_token) }
                                                   else
                                                     ->(login, oauth_token) { Struct.new(:pull_requests).new([]) }
                                                   end

