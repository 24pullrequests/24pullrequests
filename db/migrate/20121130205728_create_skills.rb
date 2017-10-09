class CreateSkills < ActiveRecord::Migration[4.2]
  def change
    create_table :skills do |t|
      t.integer :user_id
      t.string :language

      t.timestamps null: false
    end
  end
end
