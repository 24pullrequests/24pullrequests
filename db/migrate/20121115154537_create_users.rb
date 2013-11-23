class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid, :null => false
      t.string :provider, :null => false
      t.string :nickname, :null => false

      t.string :email

      t.timestamps
    end

    add_index :users, :nickname, :unique => true
    add_index :users, [:uid, :provider], :unique => true
  end
end
