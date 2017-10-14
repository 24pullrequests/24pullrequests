class CreateProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :github_url
      t.string :main_language

      t.timestamps null: false
    end
  end
end
