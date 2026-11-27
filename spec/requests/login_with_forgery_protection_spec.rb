require 'rails_helper'

describe 'Logging in with forgery protection enabled', type: :request do
  let(:user) { create :user }

  around do |example|
    original = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    example.run
  ensure
    ActionController::Base.allow_forgery_protection = original
  end

  before do
    mock_is_admin
    mock_github_auth user
  end

  it 'accepts the provider callback' do
    visit '/auth/github/callback'

    expect(current_path).to eq preferences_path
  end

  it 'rejects a callback POST without an authenticity token' do
    page.driver.post '/auth/github/callback'

    expect(page.driver.response.status).to eq 422
  end
end
