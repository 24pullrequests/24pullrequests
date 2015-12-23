class AggregationFilter < ActiveRecord::Base
  belongs_to :user

  def self.pull_request_filter
    where("pull_requests.user_id = aggregation_filters.user_id")
    .where("pull_requests.title LIKE aggregation_filters.title_pattern")
    .exists.not
  end
end
