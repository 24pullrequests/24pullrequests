class AddFeaturedToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :featured, :boolean, :default => false
    add_column :projects, :avatar_url, :string
  end
end
