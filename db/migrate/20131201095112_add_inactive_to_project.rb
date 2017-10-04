class AddInactiveToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :inactive, :boolean
  end
end
