# db/scripts/copy_archived_prs_to_prs.rb
require 'rubygems'

#to move all the archived_pull_requests back into the pull_requests table

ArchivedPullRequest.find_each do |archived_pr|
	PullRequest.create(archived_pr.attributes.except('id')).save!
end