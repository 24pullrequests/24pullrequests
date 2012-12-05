class AddTwitterUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_nickname, :string
  end
end
