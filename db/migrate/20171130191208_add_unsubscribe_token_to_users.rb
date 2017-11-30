class AddUnsubscribeTokenToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :unsubscribe_token, :string

    execute <<-PSQL
      UPDATE users
      SET unsubscribe_token = (SELECT uuid_in(md5(random()::text || now()::text)::cstring))
      WHERE unsubscribe_token IS NULL
    PSQL

    change_column_null :users, :unsubscribe_token, false
  end

  def down
    remove_column :users, :unsubscribe_token
  end
end
