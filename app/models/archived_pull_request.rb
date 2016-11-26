class ArchivedPullRequest < ApplicationRecord
  PAST_YEARS = [2014, 2013, 2012]

  belongs_to :user
  scope :year, -> (year) { where('EXTRACT(year FROM "created_at") = ?', year) }
end
