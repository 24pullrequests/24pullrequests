class AddLastScoredToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :last_scored, :datetime
  end
end
