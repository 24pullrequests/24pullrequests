class AddIndexesToSkills < ActiveRecord::Migration
  def change
    add_index :skills, :user_id
  end
end
