require 'securerandom'
require 'rspec/mocks'

FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    uid { SecureRandom.hex }
    provider 'github'
    nickname { Faker::Name.name.parameterize }
    email
    gravatar_id { Faker::Internet.email }
    token { SecureRandom.hex }
  end

  factory :skill do
    user
    language { Project::LANGUAGES.sample }
  end

  factory :pull_request do
    user
    title { Faker::Lorem.words.first }
    issue_url { Faker::Internet.url }
    body { Faker::Lorem.paragraphs.join('\n') }
    state 'open'
    merged false
    created_at { DateTime.now.to_s }
    repo_name { Faker::Lorem.words.first }
  end

  factory :project do
    description { Faker::Lorem.paragraphs.first[0..199] }
    github_url { "https://github.com/#{Faker::Lorem.words.first}/#{Faker::Lorem.words.first}" }
    name { Faker::Lorem.words.first }
    main_language { Project::LANGUAGES.sample }
  end

  factory :gift do
    user
    pull_request
  end
end
