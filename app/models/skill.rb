class Skill < ActiveRecord::Base
  belongs_to :user
  attr_accessible :language
  validates_presence_of :language
  
end
