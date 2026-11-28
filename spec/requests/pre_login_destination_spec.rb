require 'rails_helper'

describe 'Returning to the requested page after login', type: :request do
  let(:user) { create :user, email_frequency: 'daily' }

  before do
    mock_is_admin
    mock_github_auth user
  end

  it 'keeps the query string' do
    visit '/events/new?name=Hack+night'
    expect(current_path).to eq login_path

    visit '/auth/github/callback'

    expect(current_url).to eq 'http://www.example.com/events/new?name=Hack+night'
  end

  it 'keeps the scheme of the original request' do
    get 'https://www.example.com/events/new'

    expect(session[:pre_login_destination]).to eq 'https://www.example.com/events/new'
  end
end
