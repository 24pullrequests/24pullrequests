require 'rails_helper'

describe 'Static pages', :type => :request do
  subject { page }

  describe 'home page' do
    before do
      2.times { create :project }
      5.times { create :pull_request}
      visit root_path
    end

    it { is_expected.to have_link('Log in with GitHub', :href  => login_path) }
    it { is_expected.to have_content('7 Developers already involved') }
    it { is_expected.to have_content('2 Suggested Projects') }
    it { is_expected.to have_link('View All', :href  => users_path) }
    it { is_expected.to have_link('View All', :href  => projects_path) }
    it { is_expected.to have_link('View All', :href  => pull_requests_path) }
    it { is_expected.to have_link('Suggest a project', :href  => new_project_path) }
  end

  describe "humans.txt" do
    before do
      visit humans_path
    end

    it { is_expected.to have_content("CONTRIBUTORS") }
  end
end
