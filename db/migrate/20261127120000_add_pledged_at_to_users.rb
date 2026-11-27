class AddPledgedAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :pledged_at, :datetime
  end
end
