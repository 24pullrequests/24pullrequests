class AddIgnoredOrganisations < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :ignored_organisations, :string, array: true, default: nil
    User.update_all(ignored_organisations: "{}")
    change_column_default(:users, :ignored_organisations, [])
  end
end
