class AddInvalidTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :invalid_token, :boolean, default: false
  end
end
