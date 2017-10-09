class RenameOrganiserToNameInEvents < ActiveRecord::Migration[4.2]
  def change
    rename_column :events, :organiser, :name
  end
end
