class AddMergedByIdToPullRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :pull_requests, :merged_by_id, :integer
  end
end
