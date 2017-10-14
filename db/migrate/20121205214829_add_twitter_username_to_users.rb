class AddTwitterUsernameToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :twitter_nickname, :string
  end
end
