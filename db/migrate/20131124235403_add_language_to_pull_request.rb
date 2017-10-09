class AddLanguageToPullRequest < ActiveRecord::Migration[4.2]
  def change
    add_column :pull_requests, :language, :string
  end
end
