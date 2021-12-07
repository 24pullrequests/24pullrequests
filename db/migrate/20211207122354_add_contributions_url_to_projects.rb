class AddContributionsUrlToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :contributions_url, :string
  end
end
