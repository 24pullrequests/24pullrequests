class ArchivedPullRequest < ApplicationRecord
  belongs_to :user
  scope :year, -> (year) { where('EXTRACT(year FROM "created_at") = ?', year) }
end
