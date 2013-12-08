class Label < ActiveRecord::Base
  has_many :labels
  has_many :projects, through: :labels

  validates :name, presence: true
  validates_uniqueness_of :name

end
