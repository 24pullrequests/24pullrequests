class AddEmailFrequencyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_frequency, :string
  end
end
