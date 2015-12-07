class ArchivedPullRequest  < ActiveRecord::Base
  PAST_YEARS = [2014, 2013, 2012]

  belongs_to :user
  scope :year, -> (year) { where('EXTRACT(year FROM "created_at") = ?', year) }
 end
