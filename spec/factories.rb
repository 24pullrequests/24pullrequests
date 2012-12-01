require 'securerandom'

FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    uid { SecureRandom.hex }
    provider 'Github'
    nickname { Faker::Name.name }
    email
    gravatar_id { Faker::Internet.email }
    token { SecureRandom.hex }
  end
  
  factory :skill do
    user
    language { Project::LANGUAGES.sample }
  end
end
