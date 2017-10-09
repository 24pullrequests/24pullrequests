class AddContribulatorToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :contribulator, :integer
  end
end
