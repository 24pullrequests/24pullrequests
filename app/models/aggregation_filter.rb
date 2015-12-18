class AggregationFilter < ActiveRecord::Base
  belongs_to :user

  PULL_REQUEST_SQL_FILTER = 'NOT EXISTS (
    SELECT 1 FROM aggregation_filters filter
    WHERE pull_requests.user_id = filter.user_id
    AND pull_requests.repo_name LIKE filter.repo_pattern
  )'
end
