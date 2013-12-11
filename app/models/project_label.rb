class ProjectLabel < ActiveRecord::Base
  belongs_to :project
  belongs_to :label

  validates :label, presence: true
  validates :label, :uniqueness => {:scope => :project}
end
