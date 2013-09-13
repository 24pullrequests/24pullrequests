class AddConfirmableEmailFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
  end
end
