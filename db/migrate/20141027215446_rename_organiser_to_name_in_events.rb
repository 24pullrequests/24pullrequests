class RenameOrganiserToNameInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :organiser, :name
  end
end
