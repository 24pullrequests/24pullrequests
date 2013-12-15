desc "Update organisations pull_request_count"

namespace :organisations do
  task :update_pull_request_count => :environment do
    Organisation.all.each do |organisation|
      organisation.update_attribute(:pull_request_count, organisation.pull_requests.count)
    end
  end
end
