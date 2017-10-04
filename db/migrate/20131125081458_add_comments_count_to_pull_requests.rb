class AddCommentsCountToPullRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :pull_requests, :comments_count, :integer, default: 0
  end
end
