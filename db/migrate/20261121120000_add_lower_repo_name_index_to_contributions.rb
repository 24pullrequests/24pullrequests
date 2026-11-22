class AddLowerRepoNameIndexToContributions < ActiveRecord::Migration[7.1]
  def change
    add_index :contributions, 'lower(repo_name)', name: 'index_contributions_on_lower_repo_name'
  end
end
