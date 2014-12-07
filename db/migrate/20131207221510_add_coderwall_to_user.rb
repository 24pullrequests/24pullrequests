class AddCoderwallToUser < ActiveRecord::Migration
  def change
    add_column :users, :coderwall_user_name, :string
  end
end
