class AddTwitterTokenToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :twitter_token, :string
    add_column :users, :twitter_secret, :string
  end
end
