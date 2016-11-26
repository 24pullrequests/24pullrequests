class Label < ApplicationRecord
  has_many :project_labels
  has_many :projects, through: :project_labels

  validates :name, presence: true, uniqueness: true
end
