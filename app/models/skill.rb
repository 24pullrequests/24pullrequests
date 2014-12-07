class Skill < ActiveRecord::Base
  belongs_to :user
  validates :language, presence: true
end
