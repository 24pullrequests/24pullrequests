require 'spec_helper'

describe 'Dashboard', :type => :request do
  let(:user) { create :user }
  subject { page }

  before do
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

      it { is_expected.to have_content "You've not sent any pull requests, what are you waiting for?!" }
    end

    context 'when the user has unspent pull requests' do
      before do
        user.pull_requests.create(attributes_for(:pull_request))
        visit dashboard_path
      end

      it { is_expected.to have_content "Looks like you haven't gifted any code today. Would you like to gift your new pull requests?" }
      it { is_expected.to have_button "Gift it!" }
    end

    context 'when the user does not have any unspent pull requests' do
      before do
        visit dashboard_path
      end

      it { is_expected.not_to have_button "Gift it!" }
    end
  end

  describe 'email preferences' do
    before do
      visit preferences_path
    end

    it 'allows the user to set their preferences' do
      check 'Ruby'
      click_on 'Save and Continue'
      expect(user.languages).to eq ['Ruby']
    end
  end
end
