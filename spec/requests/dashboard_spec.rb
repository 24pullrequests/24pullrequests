require 'spec_helper'

describe 'Dashboard' do
  let(:user) { create :user }
  subject { page }

  before do
    login user
  end

  context 'when the user has not set their email preferences' do
    before do
      visit dashboard_path
    end

    specify { current_path.should eq preferences_path }
  end

  context 'when the user has set their email preferences' do
    before do
      user.email_frequency = 'daily'
      user.save!
      visit dashboard_path
    end

    it { should have_content "Welcome back, #{user.nickname}" }

    context 'when the user has not sent any pull requests' do
      it { should have_content "You've not sent any pull requests, what are you waiting for?!" }
    end
  end

  describe 'email preferences' do
    before do
      visit preferences_path
    end

    it 'allows the user to set their preferences' do
      check 'Ruby'
      click_on 'Save and Continue'
      user.languages.should eq ['Ruby']
    end
  end
end
