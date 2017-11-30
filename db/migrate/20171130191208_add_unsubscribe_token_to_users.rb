class AddUnsubscribeTokenToUsers < ActiveRecord::Migration[5.1]
  def up
    enable_extension 'uuid-ossp'
    add_column :users, :unsubscribe_token, :string

    execute <<-PSQL
      UPDATE users
      SET unsubscribe_token = (uuid_generate_v4())
      WHERE unsubscribe_token IS NULL
    PSQL

    change_column_null :users, :unsubscribe_token, false
    add_index :users, :unsubscribe_token, unique: true
  end

  def down
    disable_extension 'uuid-ossp'
    remove_index :users, :unsubscribe_token
    remove_column :users, :unsubscribe_token
  end
end
