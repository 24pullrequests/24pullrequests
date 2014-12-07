require 'rails_helper'

describe 'PullRequests', :type => :request do
  subject { page }

  describe 'viewing the list of users' do
    before do
      5.times { create :pull_request }
      visit pull_requests_path
    end

    it { is_expected.to have_content '5 Pull Requests already made!'}
  end
end
