class CreateOrganisations < ActiveRecord::Migration[4.2]
  def change
    create_table :organisations do |t|
      t.string :login
      t.string :avatar_url
      t.integer :github_id

      t.timestamps null: false
    end

    create_table :organisations_users do |t|
      t.integer :user_id
      t.integer :organisation_id
    end

    add_index :organisations, [:login], unique: true
  end
end
