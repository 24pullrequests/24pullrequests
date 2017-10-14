class AddThankYouEmailSentToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :thank_you_email_sent, :boolean, default: false
  end
end
