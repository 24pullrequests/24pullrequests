class AddSubmittedByToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :user_id, :integer
  end
end
