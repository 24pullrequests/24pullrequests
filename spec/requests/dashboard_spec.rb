require 'rails_helper'

describe 'Dashboard', type: :request do
  let(:user) { create :user }
  subject { page }

  before do
    mock_is_admin
    login user
  end

  context 'when the user has not set their email preferences' do
    before do
      visit dashboard_path
    end

    specify { expect(current_path).to eq preferences_path }
  end

  context 'when the user has set their email preferences' do
    before do
      user.email_frequency = 'daily'
      user.save!
    end

    it do
      visit dashboard_path
      is_expected.to have_content "Welcome back, #{user.nickname}"
    end

    context 'when the user has not sent any pull requests' do
      before do
        visit dashboard_path
      end

      it { is_expected.to have_content "You’ve not sent any pull requests, what are you waiting for?!" }
    end

    context 'when the user does not have any unspent pull requests' do
      before do
        visit dashboard_path
      end

      it { is_expected.not_to have_button 'Gift it!' }
    end
  end

  describe 'language preferences' do
    before do
      visit preferences_path
    end

    it 'allows the user to set their preferences' do
      check 'Ruby'
      click_on 'Save and Continue'
      expect(user.languages).to eq ['Ruby']
    end
  end

  describe 'ignored organisations' do
    before do
      user.ignored_organisations = %w{baz qux}
      user.email_frequency = 'daily'
      user.save!
      visit preferences_path
    end

    describe 'field' do
      before do
        visit preferences_path
      end

      it { is_expected.to have_field 'Ignored Organisations', with: 'baz, qux' }

      it 'allows the user to set their preferences' do
        fill_in 'Ignored Organisations', with: 'foo, bar'
        click_on 'Save'
        user.reload
        expect(user.ignored_organisations.sort).to eq %w{bar foo}
      end
    end

    describe 'dashboard' do
      before do
        create(:pull_request, user: user, repo_name: 'foo/bar')
        create(:pull_request, user: user, repo_name: 'baz/bar')
        visit dashboard_path
      end

      it { is_expected.to have_content 'foo/bar' }
      it { is_expected.to_not have_content 'baz/bar' }
      it { is_expected.to have_css '#pull-requests-count', text: 1 }
    end
  end
end
