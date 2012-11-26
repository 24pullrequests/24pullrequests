Rails.application.config.pull_request_downloader = if Rails.env.production?
                                                     ->(user) { PullRequestDownloader.new(user) }
                                                   else
                                                     ->(user) { Struct.new(:pull_requests).new([]) }
                                                   end

