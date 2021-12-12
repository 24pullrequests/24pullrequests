class AddLastScoredToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :last_scored, :datetime
    add_column :projects, :fork, :boolean
    add_column :projects, :github_id, :bigint
  end
end
