class AddInactiveToProject < ActiveRecord::Migration
  def change
    add_column :projects, :inactive, :boolean
  end
end
