require 'rails_helper'

describe 'Logging in', type: :request do
  let(:user) { create :user }
  subject { page }

  context 'when a guest navigates to a page that requires a user session' do
    before do
      mock_is_admin
      mock_github_auth user
      visit preferences_path
    end

    specify { expect(current_path).to eq preferences_path }
  end
end
