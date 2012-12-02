require 'spec_helper'

describe 'PullRequests' do
  subject { page }

  describe 'viewing the list of users' do
    before do
      5.times { create :pull_request }
      visit pull_requests_path
    end

    it { should have_content '5 Pull Requests already made!'}
  end
end