class AggregationFilter < ApplicationRecord
  belongs_to :user

  def self.pull_request_filter
    where("contributions.user_id = aggregation_filters.user_id")
    .where("contributions.title ILIKE aggregation_filters.title_pattern")
    .arel.exists.not
  end
end
