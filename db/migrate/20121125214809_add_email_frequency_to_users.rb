class AddEmailFrequencyToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :email_frequency, :string
  end
end
