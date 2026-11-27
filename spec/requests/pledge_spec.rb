require 'rails_helper'

describe 'Pledge', type: :request do
  subject { page }

  before { mock_is_admin }

  context 'when a user who has not pledged logs in' do
    let(:user) { create :user, pledged_at: nil }

    before { login user }

    it 'sends them to the pledge page' do
      expect(current_path).to eq pledge_path
      is_expected.to have_content I18n.t('guidelines.intro')
      is_expected.to have_content I18n.t('guidelines.items.one_pull_request')
      is_expected.to have_content I18n.t('guidelines.explanations.other_contributions')
      is_expected.to have_unchecked_field I18n.t('pledge.agree')
    end

    it 'keeps them on the pledge page until the box is ticked' do
      click_button I18n.t('pledge.continue')

      is_expected.to have_content I18n.t('pledge.must_agree')
      expect(user.reload.pledged_at).to be_nil

      visit dashboard_path
      expect(current_path).to eq pledge_path
    end

    it 'records the pledge and continues' do
      check I18n.t('pledge.agree')
      click_button I18n.t('pledge.continue')

      expect(user.reload.pledged_at).to be_present
      expect(current_path).to eq preferences_path
    end

    it 'still lets them delete their account' do
      visit delete_dashboard_path
      expect(current_path).to eq delete_dashboard_path
    end

    it 'still lets them log out' do
      visit logout_path
      expect(current_path).to eq root_path
    end
  end

  context 'when a user who has not pledged logs in from a page that needs a session' do
    let(:user) { create :user, pledged_at: nil }

    before do
      mock_github_auth user
      visit new_event_path
      click_button I18n.t('homepage.login_with_github')
    end

    it 'returns them to that page after pledging' do
      expect(current_path).to eq pledge_path

      check I18n.t('pledge.agree')
      click_button I18n.t('pledge.continue')

      expect(current_path).to eq new_event_path
    end
  end

  context 'when a user who has already pledged logs in' do
    let(:user) { create :user, email_frequency: 'daily' }

    before { login user }

    it 'takes them straight to the dashboard' do
      expect(current_path).to eq dashboard_path
    end

    it 'shows the pledge page without the form' do
      visit pledge_path

      is_expected.to have_content I18n.t('pledge.agreed')
      is_expected.not_to have_field I18n.t('pledge.agree')
    end
  end

  context 'when a guest follows the footer link' do
    before do
      visit root_path
      click_link I18n.t('pledge.public_title')
    end

    it 'shows the guidelines without the form' do
      expect(current_path).to eq pledge_path
      is_expected.to have_content I18n.t('guidelines.items.one_pull_request')
      is_expected.not_to have_field I18n.t('pledge.agree')
    end
  end

  context 'when a guest submits the pledge' do
    it 'asks them to log in' do
      page.driver.post pledge_path, agree: '1'

      expect(page.driver.response.location).to end_with login_path
    end
  end
end
