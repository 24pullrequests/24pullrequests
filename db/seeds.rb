# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# Create some test data for development environments.
if Rails.env.development?

  User.delete_all
  PullRequest.delete_all
  Gift.delete_all
  Event.delete_all
  Project.delete_all
  Label.delete_all

  require 'factory_bot_rails'
  require 'faker'
  include FactoryBot::Syntax::Methods
  LABELS = %w(documentation design tests feature refactoring)

  GRAVATARS = %w(67b26730dbb054da2aefd328708c5b0d a36d4f1831b3e2c95fa1e42fc45f82d5 b9ce9848ccbebcf4688494bf86b2a6fe cbd4648e4cd1dd7e8737c8ca91fcda02 57a90b685ef5eb6b17edf33fa91c4ea8 8ddbf811da78bb0daeeb3cacd7cf743f 0f9f17758e76da17ff4ade389e566321 fde332d18b14c52bc41b50f4952f075a 839ad4b6cf103f3ed8e05f07dbd7bccf f3c558eae6312364be3b963075c6ede5)

  ORGGRAVATARS = %w(02cd37c898f360f7bdff82b151f419f3 30f39a09e233e8369dddf6feb4be0308 fd542381031aa84dca86628ece84fc07 61024896f291303615bcd4f7a0dcfb74 406cc3bbacd9ebf8d0b8740c8d957a64 99c8b0fafa035a0a3a7f8c00e3e0fbfc)

  USERS = 50
  PULL_REQUESTS = (3..20)
  PROJECTS = 50
  DECEMBER_FIRST = Time.parse("1/12/#{Tfpullrequests::Application.current_year}")

  EVENTS = ['PullRequest-a-thon', '24 Pull Requests Hack event', 'Open Source Hackday', 'Christmas Bugmash']

  Rails.logger.info 'Inserting some test data'

  USERS.times do
    user = create :user, provider: 'developer2', gravatar_id: GRAVATARS.sample
    2.times { user.organisations << create(:organisation, avatar_url: "https://1.gravatar.com/avatar/#{ORGGRAVATARS.sample}") rescue nil }

    PULL_REQUESTS.to_a.sample.times do |i|
      date = Faker::Time.between(DECEMBER_FIRST, DECEMBER_FIRST + 23.days, :day)
      create :pull_request, user: user, created_at: date
    end
    user.gift_unspent_pull_requests!
  end

  labels = LABELS.map do |name|
    Label.create name: name
  end

  PROJECTS.times do
    project = create :project
    project.labels << labels.sample(2)
  end

  EVENTS.each do |event_name|
    Event.create name: event_name,
                 location: "#{Faker::Address.city}, #{Faker::Address.country}",
                 url: Faker::Internet.url,
                 start_time:  Faker::Time.between(DECEMBER_FIRST, DECEMBER_FIRST + 23.days, :day),
                 latitude: Faker::Address.latitude,
                 longitude: Faker::Address.longitude,
                 description: Faker::Lorem.sentence(3),
                 user_id: User.take(1).first.id
  end

end
