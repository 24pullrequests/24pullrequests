require 'rails_helper'

describe 'Contributions from users who have not pledged', type: :request do
  subject { page }

  let(:pledged_user) { create :user }
  let(:unpledged_user) { create :user, pledged_at: nil }
  let(:project) { create :project, github_url: 'https://github.com/octocat/hello' }

  before do
    create :contribution, user: pledged_user, title: 'Visible change', repo_name: 'octocat/hello', language: 'Ruby'
    create :contribution, user: unpledged_user, title: 'Hidden change', repo_name: 'octocat/hello', language: 'Ruby'
  end

  shared_examples 'a page that hides them' do
    it { is_expected.to have_content 'Visible change' }
    it { is_expected.not_to have_content 'Hidden change' }
  end

  describe 'the homepage' do
    before { visit root_path }

    it_behaves_like 'a page that hides them'
    it { is_expected.to have_content 'Latest Contributions (1 total)' }
  end

  describe 'the contributions list' do
    before { visit pull_requests_path }

    it_behaves_like 'a page that hides them'
    it { is_expected.to have_content '1 contributions already made!' }
  end

  describe 'the language contributions list' do
    before { visit pull_requests_language_path('ruby') }

    it_behaves_like 'a page that hides them'
  end

  describe 'the project page' do
    before { visit project_path(project) }

    it_behaves_like 'a page that hides them'
    it { is_expected.not_to have_content unpledged_user.nickname }
  end

  describe 'the contribution page' do
    it 'is not found' do
      visit contribution_path(unpledged_user.contributions.first)

      expect(page.status_code).to eq 404
    end
  end

  describe 'the user list' do
    before { visit users_path }

    it 'counts no contributions for the unpledged user' do
      expect(unpledged_user.reload.contributions_count).to eq 0
      expect(pledged_user.reload.contributions_count).to eq 1
    end
  end

  describe 'their profile' do
    before { visit user_path(unpledged_user) }

    it { is_expected.not_to have_content 'Hidden change' }
  end

  describe 'their profile as JSON' do
    it 'lists no pull requests' do
      visit user_path(unpledged_user, format: :json)

      expect(JSON.parse(page.body)['pull_requests']).to be_empty
    end
  end

  describe 'after they pledge' do
    before do
      unpledged_user.pledge!
      visit pull_requests_path
    end

    it { is_expected.to have_content 'Hidden change' }

    it 'counts their contributions' do
      expect(unpledged_user.reload.contributions_count).to eq 1
    end
  end
end
