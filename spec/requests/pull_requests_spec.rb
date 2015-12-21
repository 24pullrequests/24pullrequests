require 'rails_helper'

describe 'PullRequests', type: :request do
  subject { page }

  describe 'viewing the list of users' do
    before do
      5.times { create :pull_request }
      visit pull_requests_path
    end

    it { is_expected.to have_content '5 Pull Requests already made!' }
  end

  describe 'Users' do
    before do
      user = create :user
      create :pull_request, user: user
      create :pull_request, user_id: nil
      visit pull_requests_path
    end

    it 'Only show the image when there is a user' do
      expect(page.all('.pull_request a.image').length).to eq(1)
    end
  end
end
