class RenameContributionsUrl < ActiveRecord::Migration[5.2]
  def change
    rename_column :projects, :contributions_url, :contributing_url
  end
end
