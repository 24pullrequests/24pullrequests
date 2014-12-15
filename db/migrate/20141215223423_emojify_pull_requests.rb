include EmojiHelper

class EmojifyPullRequests < ActiveRecord::Migration
  def change
    PullRequest.all.each do |pull_request|
      pull_request.body = emojify(pull_request.body)
      pull_request.save!
    end
  end
end
