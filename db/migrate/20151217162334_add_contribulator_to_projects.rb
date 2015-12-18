class AddContribulatorToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :contribulator, :integer
  end
end
