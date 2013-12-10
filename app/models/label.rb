class Label < ActiveRecord::Base
  has_many :project_labels
  has_many :projects, through: :project_labels

  validates :name, presence: true
  validates_uniqueness_of :name

end
