class AddHomepageToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :homepage, :string
  end
end
