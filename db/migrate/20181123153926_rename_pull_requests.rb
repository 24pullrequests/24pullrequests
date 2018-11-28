class RenamePullRequests < ActiveRecord::Migration[5.2]
  def change
    rename_table :pull_requests, :contributions
    rename_column :gifts, :pull_request_id, :contribution_id
    rename_column :organisations, :pull_request_count, :contribution_count
    rename_column :users, :pull_requests_count, :contributions_count
  end
end
