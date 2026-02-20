class ContributionTimestampNormalization < ApplicationRecord
  belongs_to :contribution

  validates :contribution_id, uniqueness: true
  validates :original_created_at, :normalized_created_at, :applied_timezone, :normalized_at, presence: true
end
