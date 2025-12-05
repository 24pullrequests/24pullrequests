require 'rails_helper'

describe 'Logging in', type: :request do
  let(:user) { create :user }
  subject { page }

  context 'when visiting the login page' do
    before do
      visit login_path
    end

    it 'shows a login form' do
      expect(page).to have_button(I18n.t('homepage.login_with_github'))
    end
  end

  context 'when a guest navigates to a page that requires a user session' do
    before do
      mock_is_admin
      mock_github_auth user
      visit preferences_path
      click_button I18n.t('homepage.login_with_github')
    end

    specify { expect(current_path).to eq preferences_path }
  end

  context 'when clicking host an event while logged out' do
    before do
      mock_is_admin
      mock_github_auth user
      visit new_event_path
      click_button I18n.t('homepage.login_with_github')
    end

    specify { expect(current_path).to eq new_event_path }
  end
end
