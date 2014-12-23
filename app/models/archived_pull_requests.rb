class ArchivedPullRequest < ActiveRecord::Base
  belongs_to :user

  scope :year, -> (year) { where('EXTRACT(year FROM "created_at") = ?', year) }
end
