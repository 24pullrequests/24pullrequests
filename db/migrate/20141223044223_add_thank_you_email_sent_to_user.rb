class AddThankYouEmailSentToUser < ActiveRecord::Migration
  def change
    add_column :users, :thank_you_email_sent, :boolean, default: false
  end
end
