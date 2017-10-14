class AddGravatarIdToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :gravatar_id, :string
  end
end
