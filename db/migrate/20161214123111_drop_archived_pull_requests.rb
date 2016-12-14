class DropArchivedPullRequests < ActiveRecord::Migration[5.0]
  def change
  	drop_table :archived_pull_requests
  end
end
