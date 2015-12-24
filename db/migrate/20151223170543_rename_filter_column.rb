class RenameFilterColumn < ActiveRecord::Migration
  def change
    rename_column :aggregation_filters, :repo_pattern, :title_pattern
  end
end
