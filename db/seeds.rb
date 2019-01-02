# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# Create some test data for development environments.
if Rails.env.development? || Rails.env.test?

  User.delete_all
  Contribution.delete_all
  Gift.delete_all
  Event.delete_all
  Project.delete_all
  Label.delete_all

  require 'factory_bot_rails'
  require 'faker'
  include FactoryBot::Syntax::Methods
  default_labels = %w(documentation design tests feature refactoring)

  gravatars = %w(67b26730dbb054da2aefd328708c5b0d a36d4f1831b3e2c95fa1e42fc45f82d5 b9ce9848ccbebcf4688494bf86b2a6fe cbd4648e4cd1dd7e8737c8ca91fcda02 57a90b685ef5eb6b17edf33fa91c4ea8 8ddbf811da78bb0daeeb3cacd7cf743f 0f9f17758e76da17ff4ade389e566321 fde332d18b14c52bc41b50f4952f075a 839ad4b6cf103f3ed8e05f07dbd7bccf f3c558eae6312364be3b963075c6ede5)

  org_gravatars = %w(02cd37c898f360f7bdff82b151f419f3 30f39a09e233e8369dddf6feb4be0308 fd542381031aa84dca86628ece84fc07 61024896f291303615bcd4f7a0dcfb74 406cc3bbacd9ebf8d0b8740c8d957a64 99c8b0fafa035a0a3a7f8c00e3e0fbfc)

  users = 50
  pull_requests = (3..20)
  projects = 50
  december_first = Time.parse("1/12/#{Tfpullrequests::Application.current_year}")

  events = ['PullRequest-a-thon', '24 Pull Requests Hack event', 'Open Source Hackday', 'Christmas Bugmash']

  Rails.logger.info 'Inserting some test data'

  users.times do
    user = create :user, provider: 'developer2', gravatar_id: gravatars.sample
    2.times { user.organisations << create(:organisation, avatar_url: "https://1.gravatar.com/avatar/#{org_gravatars.sample}") rescue nil }

    pull_requests.to_a.sample.times do |i|
      date = Faker::Time.between(december_first, december_first + 23.days, :day)
      create :contribution, user: user, created_at: date
    end
    user.gift_unspent_contributions!
  end

  labels = default_labels.map do |name|
    Label.create name: name
  end

  projects.times do
    project = create :project, submitted_by: User.take(1).first
    project.labels << labels.sample(2)
  end

  events.each do |event_name|
    Event.create name: event_name,
                 location: "#{Faker::Address.city}, #{Faker::Address.country}",
                 url: Faker::Internet.url,
                 start_time:  Faker::Time.between(december_first, december_first + 23.days, :day),
                 latitude: Faker::Address.latitude,
                 longitude: Faker::Address.longitude,
                 description: Faker::Lorem.sentence(3),
                 user_id: User.take(1).first.id
  end

end
