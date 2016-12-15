desc 'Copy archived prs to prs'
task copy_archived_prs_to_prs: :environment do
  ArchivedPullRequest.all.find_each do |archived_pr|
    PullRequest.create(archived_pr.attributes.except('id')).save!
  end
end
