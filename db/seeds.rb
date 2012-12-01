# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# Create some test data for development environments.
if Rails.env.development? && User.count == 0
  require 'factory_girl_rails'
  require 'faker'
  include FactoryGirl::Syntax::Methods

  GRAVATARS = [
    '67b26730dbb054da2aefd328708c5b0d',
    'a36d4f1831b3e2c95fa1e42fc45f82d5',
    'cbd4648e4cd1dd7e8737c8ca91fcda02',
    '57a90b685ef5eb6b17edf33fa91c4ea8',
    '8ddbf811da78bb0daeeb3cacd7cf743f',
    '0f9f17758e76da17ff4ade389e566321',
    'fde332d18b14c52bc41b50f4952f075a',
    '839ad4b6cf103f3ed8e05f07dbd7bccf',
    'f3c558eae6312364be3b963075c6ede5'
  ]

  USERS = 50
  PULL_REQUESTS = (0..20)
  PROJECTS = 50

  puts 'Inserting some test data'

  USERS.times do
    user = create :user, gravatar_id: GRAVATARS.sample
    user.uid = user.nickname # For developer2 omniauth
    user.save!
    PULL_REQUESTS.to_a.sample.times do
      create :pull_request, user: user
    end
  end

  PROJECTS.times do
    project = create :project
  end
end
