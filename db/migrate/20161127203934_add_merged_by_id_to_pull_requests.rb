class AddMergedByIdToPullRequests < ActiveRecord::Migration
  def change
    add_column :pull_requests, :merged_by_id, :integer
  end
end
