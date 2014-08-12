require 'spec_helper'

describe 'Dashboard' do
  include PullRequestHelper

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
    end

    it do
      visit dashboard_path
      should have_content "Welcome back, #{user.nickname}"
    end

    context 'when the user has not sent any pull requests' do
      before do
        visit dashboard_path
      end

      it { should have_content "You've not sent any pull requests, what are you waiting for?!" }
    end

    context 'when the user has unspent pull requests' do
      before do
        user.pull_requests.create(attributes_for(:pull_request))
        visit dashboard_path
      end

      it { should have_content "Looks like you haven't gifted any code today. Would you like to gift your new pull requests?" }
      it { should have_button "Gift it!" }
    end

    context 'when the user does not have any unspent pull requests' do
      before do
        visit dashboard_path
      end

      it { should_not have_button "Gift it!" }
    end
  end

  context 'when the user has sent pull requests' do
    before do
      user.email_frequency = 'daily'
      user.save!
      5.times { create(:pull_request, user: user) }
      visit dashboard_path
    end

    it 'should invite the user to gift new pull requests' do
      page.should have_content "Would you like to gift your new pull requests?"
      page.all('#gift_pull_request_id option').count.should eql 5
    end

    it 'should list the user\'s pull requests' do
      page.all('#pull-requests .pull_request').count.should eql 5
    end

    context 'when synchronising an additional pull request' do
      let!(:new_pr) { create(:pull_request, user: user) }
      before do
        click_on 'fetch-pull-requests'
        sleep 2 #TODO This shouldn't be necessary! page.find('#spinner', visible: false) does not wait, however
      end

      it 'should list the additional pull request and make it available to gift', js: true do
        # There should be 6 items in both the pull requests div and the gift dropdown
        page.all('#pull-requests .pull_request').count.should eql 6
        page.all('#gift_pull_request_id option').count.should eql 6

        # The new PR should be the first item in the pull requests div
        page.all('#pull-requests .pull_request h4 a')[0].text.should eql new_pr.title

        # The new PR should be the last item in the gift dropdown
        new_pr_dropdown_text = gift_dropdown_text(new_pr)
        new_pr_option = page.all('#gift_pull_request_id option')[-1]
        new_pr_option.text.should eql new_pr_dropdown_text
        new_pr_option['value'].should eql new_pr.to_param.to_s
      end
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
