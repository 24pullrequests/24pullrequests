class AddLastSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_sent_at, :datetime
  end
end
