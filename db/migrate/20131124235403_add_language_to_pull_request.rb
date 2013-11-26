class AddLanguageToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :language, :string
  end
end
