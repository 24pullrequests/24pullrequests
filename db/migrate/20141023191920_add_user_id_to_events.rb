class AddUserIdToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :user_id, :integer
  end
end
