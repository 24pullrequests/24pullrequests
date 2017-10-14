class AddIndexesToPullRequest < ActiveRecord::Migration[4.2]
  def change
    add_index :pull_requests, :user_id
  end
end
