class AddPullRequestCountToOrganisation < ActiveRecord::Migration
  def change
    add_column :organisations, :pull_request_count, :integer, default: 0
  end
end
