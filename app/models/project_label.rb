class ProjectLabel < ApplicationRecord
  belongs_to :project
  belongs_to :label

  validates :label_id, presence: true
  validates :label_id, uniqueness: { scope: :project_id }
end
