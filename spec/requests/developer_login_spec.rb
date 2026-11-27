require 'rails_helper'

describe 'Local developer login', type: :request do
  around do |example|
    OmniAuth.config.test_mode = false
    example.run
  ensure
    OmniAuth.config.test_mode = true
  end

  before do
    mock_is_admin
    allow_any_instance_of(User).to receive(:download_contributions)
    allow_any_instance_of(User).to receive(:download_user_organisations)
  end

  def login_as(nickname)
    visit "/auth/developer2/callback?nickname=#{nickname}"
  end

  it 'lets the same nickname log in more than once' do
    login_as 'local-dev'
    visit logout_path
    login_as 'local-dev'

    expect(current_path).to eq preferences_path
    expect(User.where(nickname: 'local-dev').count).to eq 1
  end

  it 'creates a separate user for each nickname' do
    login_as 'local-dev'
    visit logout_path
    login_as 'other-dev'

    expect(User.where(nickname: %w[local-dev other-dev]).pluck(:uid).uniq.length).to eq 2
  end
end
