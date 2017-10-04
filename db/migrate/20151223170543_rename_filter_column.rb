class RenameFilterColumn < ActiveRecord::Migration[4.2]
  def change
    rename_column :aggregation_filters, :repo_pattern, :title_pattern
  end
end
