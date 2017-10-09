class AddLastSentAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :last_sent_at, :datetime
  end
end
