class AddIndexesToPullRequest < ActiveRecord::Migration
  def change
    add_index :pull_requests, :user_id
  end

end
