require 'spec_helper'

describe 'Logging in' do
  let(:user) { create :user }
  subject { page }

  context 'when a guest navigates to a page that requires a user session' do
    before do
      mock_github_auth user
      visit preferences_path
    end

    specify { current_path.should eq preferences_path }
  end
end
