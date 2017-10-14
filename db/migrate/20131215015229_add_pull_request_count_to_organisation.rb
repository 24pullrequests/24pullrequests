class AddPullRequestCountToOrganisation < ActiveRecord::Migration[4.2]
  def change
    add_column :organisations, :pull_request_count, :integer, default: 0
  end
end
