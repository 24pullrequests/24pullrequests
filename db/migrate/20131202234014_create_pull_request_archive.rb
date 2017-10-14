class CreatePullRequestArchive < ActiveRecord::Migration[4.2]
  def change
    create_table :pull_request_archives do |t|
      t.string 'title'
      t.string 'issue_url'
      t.text 'body'
      t.string 'state'
      t.boolean 'merged'
      t.datetime 'created_at'
      t.string 'repo_name'
      t.integer 'user_id'
      t.string 'language'
      t.integer 'comments_count', default: 0
    end
  end
end
