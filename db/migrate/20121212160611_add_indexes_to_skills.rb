class AddIndexesToSkills < ActiveRecord::Migration[4.2]
  def change
    add_index :skills, :user_id
  end
end
