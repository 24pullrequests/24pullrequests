require 'securerandom'
require 'rspec/mocks'

FactoryGirl.define do
  factory :aggregation_filter do
    user nil
    title_pattern "MyString"
  end

  sequence :email do |n|
    "email#{n}@factory.com"
  end

  sequence :user_name do |n|
    "#{Faker::Internet.user_name}#{n}"
  end

  sequence :integer_id do |n|
    n
  end

  sequence :github_url do |n|
    "https://github.com/#{Faker::Lorem.word}-#{n}/#{Faker::Lorem.word}-#{n}"
  end

  factory :user do
    sequence(:uid)
    provider 'github'
    nickname { Faker::Name.name.parameterize }
    email
    gravatar_id { Faker::Internet.email }
    token { SecureRandom.hex }
    location { Faker::Address.country }
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
    language { Project::LANGUAGES.sample }
  end

  factory :project do
    description { Faker::Lorem.paragraphs.first[0..199] }
    github_url
    name { Faker::Lorem.words.first }
    main_language { Project::LANGUAGES.sample }
    submitted_by { create(:user) }
  end

  factory :label do
    name { %w(documentation design tests feature refactoring).sample }
  end

  factory :gift do
    user
    pull_request
  end

  factory :organisation do
    github_id { generate(:integer_id) }
    login { generate(:user_name) }
  end

  factory :event do
    name { 'BristolJS' }
    location { 'BristolUK' }
    url { 'http://google.com' }
    start_time { Time.parse("1st December #{Tfpullrequests::Application.current_year}") }
    latitude { 51.4 }
    longitude { -2.6 }
    description { Faker::Lorem.paragraphs.first[0..199] }
    user
  end
end
